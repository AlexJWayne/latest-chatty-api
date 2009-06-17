class Settings < ActiveRecord::Base
  class SettingNotFound < RuntimeError; end
  
  cattr_accessor :defaults
  @@defaults = {}.with_indifferent_access
  
  # Support old plugin
  if defined?(SettingsDefaults::DEFAULTS)
    @@defaults = SettingsDefaults::DEFAULTS.with_indifferent_access
  end
  
  #get or set a variable with the variable as the called method
  def self.method_missing(method, *args)
    method_name = method.to_s
    super(method, *args)
    
  rescue NoMethodError
    #set a value for a variable
    if method_name =~ /=$/
      var_name = method_name.gsub('=', '')
      value = args.first
      self[var_name] = value
    
    #retrieve a value
    else
      self[method_name]
      
    end
  end
  
  #destroy the specified settings record
  def self.destroy(var_name)
    var_name = var_name.to_s
    if self[var_name]
      object(var_name).destroy
      true
    else
      raise SettingNotFound, "Setting variable \"#{var_name}\" not found"
    end
  end

  #retrieve all settings as a hash
  def self.all
    vars = find(:all, :select => 'var, value')
    
    result = {}
    vars.each do |record|
      result[record.var] = record.value
    end
    result.with_indifferent_access
  end
  
  #retrieve a setting value by [] notation
  def self.[](var_name)
    if var = object(var_name)
      var.value
    elsif @@defaults[var_name.to_s]
      @@defaults[var_name.to_s]
    else
      nil
    end
  end
  
  #set a setting value by [] notation
  def self.[]=(var_name, value)
    var_name = var_name.to_s
    
    record = object(var_name) || Settings.new(:var => var_name)
    record.value = value
    record.save
  end
  
  #retrieve the actual Setting record
  def self.object(var_name)
    Settings.find_by_var(var_name.to_s)
  end
  
  #get the value field, YAML decoded
  def value
    YAML::load(self[:value])
  end
  
  #set the value field, YAML encoded
  def value=(new_value)
    self[:value] = new_value.to_yaml
  end
  
  #Deprecated!
  def self.reload # :nodoc:
    self
  end
end
