require 'ezcrypto'

class Device < ActiveRecord::Base
  class PushPerformer
    def perform
      Device.push
    end
  end
  
  before_create :set_last_push
  
  def self.push
    Device.delete_all(['updated_at < ?', 1.month.ago])
    Device.all.each(&:push)
  end
  
  def self.perform
    push_new_messages
  end
  
  def set_last_push
    self.last_push = Time.now
  end
  
  def push
    push_new_messages
  end
  
  def push_new_messages
    messages = Message.fetch(username, password)
    message_count = messages.select(&:unread).size
    
    new_messages = messages.select do |message|
      message.unread && message.date > last_push
    end
    
    if new_messages.any?
      Pusher.push(token, "New Message from #{new_messages.last.from}", :badge => message_count, :custom => { :message_id => messages.last.id })
      logger.info "Pushed #{new_messages.size} message(s) to <#{token}>"
    end
    
    update_attribute :last_push, Time.now
  end
  
  def encryption_key
    @encryption_key ||= EzCrypto::Key.with_password(username, Settings.salt)
  end
  
  def password
    encryption_key.decrypt64(password_encrypted)
  end
  
  def password=(new_password)
    self.password_encrypted = encryption_key.encrypt64(new_password)
  end
end
