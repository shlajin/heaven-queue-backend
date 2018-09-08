class ApplicationJob < ActiveJob::Base
  # Pubsub doesn't allow to store nested hashes, inner hashes are serialized into Strings.
  # Since Ruby has fancy syntax for hashes which isn't easy to deserialize, we have to
  # tap here and make force it to use JSON
  def deserialize(job_data)
    super
    self.serialized_arguments = JSON.parse job_data["arguments"]
  end

  def serialize
    # Way less fancy than Arguments.serialize, but apparently the easiest way for now
    super.merge({
      arguments: arguments&.to_json
    })
  end
end
