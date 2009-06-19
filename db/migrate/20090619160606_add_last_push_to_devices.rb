class AddLastPushToDevices < ActiveRecord::Migration
  def self.up
    add_column :devices, :last_push, :datetime
  end

  def self.down
    remove_column :devices, :last_push
  end
end
