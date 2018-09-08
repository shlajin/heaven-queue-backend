class Adapter::Stream
  # incapsulates the logic to work with gcloud pubsub.
  # use this class to communicate with gcloud pubsub service

  def initialize(topic_key: :topic, subscription_key: :subscription)
    @topic_key = topic_key
    @subscription_key = subscription_key

    Adapter::Options.validate!
  end

  def publish(*args, &block)
    topic.publish *args, &block
  end

  def listen(&block)
    subscription.listen &block
  end

  private

  def topic
    @topic ||= pubsub.topic Adapter::Options.get(@topic_key)
  end

  def subscription
    @subscription ||= topic.subscription Adapter::Options.get(@subscription_key)
  end

  def pubsub
    @pubsub ||= Google::Cloud::Pubsub.new project_id: Adapter::Options.get(:project_id)
  end
end
