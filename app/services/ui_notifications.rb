# Namespace for Foreman UI notifications event handling
module UINotifications
  class Base
    attr_reader :subject

    def self.deliver!(subject)
      new(subject).deliver!
    rescue => e
      # Do not break actions using notifications even if there is a failure.
      logger.warn("Failed to handle notifications - this is most likely a bug: #{e}")
    end

    def self.logger
      @logger ||= Foreman::Logging.logger('notifications')
    end

    def initialize(subject)
      raise(Foreman::Exception, 'must provide notification subject') if subject.nil?
      @subject = subject
    end

    def deliver!
      logger.debug("Notification event: #{event} - checking for notifications")
      create
    end

    protected

    def event
      self.class.name.sub(/^\w+::/,'')
    end

    # Defaults to anonymous api admin, override in subclasses as needed.
    def initiator
      User.anonymous_api_admin
    end

    def logger
      self.class.logger
    end
  end
end
