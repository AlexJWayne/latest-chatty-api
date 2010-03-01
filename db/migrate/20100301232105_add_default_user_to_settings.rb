class AddDefaultUserToSettings < ActiveRecord::Migration
  def self.up
    Settings.default_user = {
      :username => "latestchatty",
      :password => "8675309",
    }
  end

  def self.down
  end
end
