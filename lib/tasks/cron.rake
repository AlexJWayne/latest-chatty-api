task :cron => :environment do
  Device.push
end