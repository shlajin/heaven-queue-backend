class Worker::Counter
  def initialize
    # Hash format: [job_id] => executions count
    @attempts = { }
  end

  def job_started!(job_id)
    @attempts[job_id] = ( @attempts[job_id] || 0 ) + 1
  end

  def dead_job?(job_id)
    attempts_count_for(job_id) >= Adapter::Options.get(:retry_count)
  end

  def remove_job!(job_id)
    @attempts.delete job_id
  end

  def attempts_count_for(job_id)
    @attempts[job_id] || 0
  end
end
