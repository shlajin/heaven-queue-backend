class Worker
  DELAY_BETWEEN_RETRIES = 1.seconds

  def self.run(*args)
    new(*args).run
  end

  def run
    jobs_counter = Worker::Counter.new

    subscriber = stream.listen do |message|
      attributes = message.attributes
      job_id = attributes['job_id']

      begin
        jobs_counter.job_started! job_id
        job = ActiveJob::Base.deserialize attributes
        job.executions = jobs_counter.attempts_count_for(job_id) - 1

        job.perform_now

        message.acknowledge!
      rescue StandardError => error
        if jobs_counter.dead_job? job_id
          # job can be `nil` if we failed to deserialize it (e.g. job name is wrong).
          if job
            job.enqueue(queue: :morgue)
          else
            say "Job with id #{job_id} is not queued to morgue because it's not a valid job"
          end
          message.acknowledge!
          jobs_counter.remove_job! job_id
          say "Job with id #{job_id} moved to morgue"
        else
          # try again
          say "Job with id #{job_id} failed to finish. Trying again later..."
          message.delay! Adapter::Options.get(:delay_between_retries)
        end
      end
    end

    subscriber.on_error do |error|
      say error
      say error.backtrace
    end

    Signal.trap("INT") do
      metrics.stop_reporting
      say "Allowing worker to gracefully quit ... hit ctrl+C again to force quit"
      exit
    end

    metrics.start_collecting!
    metrics.start_reporting { |message| say message }
    subscriber.start

    sleep
  end

  private

  def stream
    @stream ||= Adapter::Stream.new
  end

  def metrics
    @metrics ||= Worker::MetricsCollector.new
  end

  def say(message)
    # Quick'n'dirty - ensuring message gets delivered to stdout
    puts "Worker -> #{message}"
  end
end
