class FailingJob < ApplicationJob
  def perform(message)
    puts "[FailingJob]: #{message}, attempts count: #{executions}"
    raise 'I love to fail!'
  end
end
