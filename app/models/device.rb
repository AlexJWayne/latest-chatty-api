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
      Pusher.push(token, "New Message from #{new_messages.last.from}", :badge => message_count)
      logger.info "Pushed #{new_messages.size} message(s) to <#{token}>"
    end
    
    update_attribute :last_push, Time.now
  end
end
