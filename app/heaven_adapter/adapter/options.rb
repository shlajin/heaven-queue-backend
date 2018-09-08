class Adapter::Options
  @options = {
    topic: nil,
    dead_topic: nil,
    subscription: nil,
    project_id: nil,
    delay_between_retries: 5.seconds.to_i,
    retries_count: 3,
  }

  def self.configure(&block)
    yield self if block_given?
  end

  def self.get(key)
    @options[key&.to_sym]
  end

  def self.validate!
    missing_options = @options.select { |_, v| v.blank? }.keys
    if missing_options.present?
      raise StandardError.new("
        Please configure Heaven before using.
        These options are missing: #{missing_options.join(', ')}".squish)
    end

    true
  end

  @options.keys.map(&:to_sym).each do |method_name|
    define_singleton_method method_name do |value|
      @options[method_name] = value
    end
  end
end
