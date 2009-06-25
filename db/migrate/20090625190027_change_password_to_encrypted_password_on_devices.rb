class ChangePasswordToEncryptedPasswordOnDevices < ActiveRecord::Migration
  def self.up
    rename_column :devices, :password, :password_encrypted
    Settings.salt = "abc123"
  end

  def self.down
    rename_column :devices, :password_encrypted, :password
  end
end
