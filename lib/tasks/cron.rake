task :cron => :environment do
  Device.push_new_messages
end