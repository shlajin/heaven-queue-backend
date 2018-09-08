class SuccessJob < ApplicationJob
  def perform(message)
    puts "[SuccessJob]: #{message}, attempts count: #{executions} (I never fail!)"
  end
end
