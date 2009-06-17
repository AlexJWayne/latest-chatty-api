class Device < ActiveRecord::Base
  def self.push_new_messages
    # Only push to devices for a month without re-registering
    Device.delete_all(['updated_at < ?', 1.month.ago])
    
    # Push all devices
    Device.all.each(&:push_new_messages)
    
    # Set last push check time
    Settings.last_push = Time.now
  end
  
  def push_new_messages
    messages = Message.fetch(username, password)
    message_count = messages.select(&:unread).size
    
    new_messages = messages.select do |message|
      message.unread && Time.parse(message.date) > Settings.last_push
    end
    
    if new_messages.any?
      Pusher.push(token, "New Message from #{new_messages.last.from}", :badge => message_count)
    end
  end
end
