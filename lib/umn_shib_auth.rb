module UmnShibAuth
  require 'umn_shib_auth/session'
  require 'umn_shib_auth/controller_methods'

  class StubbingNotEnabled < StandardError; end

  mattr_accessor :eppn_variable, :emplid_variable, :display_name_variable

  def self.set_global_defaults!
    self.eppn_variable = 'eppn'
    self.emplid_variable = 'umnEmplId'
    self.display_name_variable = 'displayName'
  end

  @masquerade_mappings ||= nil
  mattr_reader :masquerade_mappings
  def self.masquerade(h)
    raise "must be hash" unless h.is_a? Hash
    @masquerade_mappings = h
  end

  def self.masquerade_set_for_internet_id?(internet_id)
    return false if @masquerade_mappings.nil?
    return true if @masquerade_mappings[internet_id].is_a? String
  end

  def self.masquerade_internet_id_for_actual_internet_id(internet_id)
    @masquerade_mappings[internet_id]
  end

  #
  def self.using_stub_internet_id?
    stubbing_enabled? && ENV.key?('STUB_INTERNET_ID')
  end

  def self.stubbing_enabled?
    ["development", "test"].include?(Rails.env)
  end

  def self.stub_internet_id
    raise StubbingNotEnabled unless using_stub_internet_id?
    ENV['STUB_INTERNET_ID'] || ENV['STUB_X500']
  end

  def self.stub_emplid
    raise StubbingNotEnabled unless using_stub_internet_id?
    ENV['STUB_EMPLID']
  end

  def self.stub_display_name
    raise StubbingNotEnabled unless using_stub_internet_id?
    ENV['STUB_DISPLAY_NAME']
  end

  @session_stub = nil
  def self.session_stub
    if @session_stub.nil?
    end
    @session_stub
  end

  set_global_defaults!
end
