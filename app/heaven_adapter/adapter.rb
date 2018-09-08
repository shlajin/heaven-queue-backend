require "google/cloud/pubsub"

class Adapter
  class << self
    def configure(&block)
      Adapter::Options.configure(&block)
    end

    def enqueue(job)
      find_stream_for_job(job).publish job.serialize
    end

    def enqueue_at(*args)
      raise NotImplementedError.new('Scheduling a job is not supported')
    end

    private

    def alive_stream
      @alive_stream ||= Adapter::Stream.new
    end

    def dead_stream
      @dead_stream ||= Adapter::Stream.new(topic_key: :dead_topic)
    end

    def find_stream_for_job(job)
      case job.queue_name
      when 'default'
        alive_stream
      when 'morgue'
        dead_stream
      else
        raise ArgumentError.new("Queue names other than default and morgue are not supported")
      end
    end
  end
end
