xml.instruct!
xml.comment! 'Documentation at http://shackchatty.com/readme'
xml.messages :user => @username do
  @messages.each do |message|
    xml.message message.body, :id => message.id, :from => message.from, :subject => message.subject, :date => message.date, :unread => message.unread.inspect
  end
end