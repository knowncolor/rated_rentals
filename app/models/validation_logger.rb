module ValidationLogger
  def self.included(base)
    base.send :include, InstanceMethods
    base.after_validation :log_errors, if: ->(m) { m.errors.present? }
  end

  module InstanceMethods
    def log_errors
      Rails.logger.warn "Validation Error: #{self.class.name} #{self.id || '(new)'} is invalid: #{self.errors.full_messages.inspect}"
    end
  end
end