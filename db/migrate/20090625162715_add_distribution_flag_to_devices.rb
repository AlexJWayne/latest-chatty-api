class AddDistributionFlagToDevices < ActiveRecord::Migration
  def self.up
    add_column :devices, :distribution, :boolean
  end

  def self.down
    remove_column :devices, :distribution
  end
end
