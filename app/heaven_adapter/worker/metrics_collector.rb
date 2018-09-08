class Worker::MetricsCollector
  def initialize
    @count_success = 0
    @count_total = 0
    @duration = 0
  end

  def start_collecting!
    @start_collection_at = Time.current
    @subscription = ActiveSupport::Notifications.subscribe 'perform.active_job' do |*args|
      name, started, finished, unique_id, job = args

      @duration += finished - started
      @count_total += 1
      @count_success += 1 if job[:exception].nil?
    end
  end

  def stop_collecting!
    ActiveSupport::Notifications.unsubscribe @subscription if @subscription
  end

  def start_reporting(&block)
    @reporting = true
    Thread.new do
      while @reporting
        yield status
        sleep 5
      end
    end
  end

  def stop_reporting
    @reporting = false
  end

  def status
    "Processed #{@count_success} jobs successfully
     (of #{@count_total} total) in #{@duration.to_i}
     seconds (worker ran for #{@start_collection_at ? (Time.current - @start_collection_at).to_i : '-'}
     seconds)".squish
  end
end
