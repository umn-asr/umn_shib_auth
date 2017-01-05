module UmnShibAuth
  require 'umn_shib_auth/session'
  require 'umn_shib_auth/controller_methods'

  ENABLE_STUB_FILE = File.join(ENV['HOME'], ".umn_shib_auth_enable_stub").freeze

  mattr_accessor :eppn_variable

  def self.set_global_defaults!
    self.eppn_variable = 'eppn'
  end

  @@masquerade_mappings ||= nil
  mattr_reader :masquerade_mappings
  def self.masquerade(h)
    raise "must be hash" unless h.kind_of? Hash
    @@masquerade_mappings = h
  end

  def self.masquerade_set_for_internet_id?(internet_id)
    return false if @@masquerade_mappings.nil?
    return true if @@masquerade_mappings[internet_id].kind_of? String
  end

  def self.masquerade_internet_id_for_actual_internet_id(internet_id)
    # TODO: redefine this exception raise MasqueradeNotSet.new("Use masquerade_set_for_internet_id? first before calling this method") unless self.masquerade_set_for_internet_id?(internet_id)
    @@masquerade_mappings[internet_id]
  end

  #
  def self.using_stub_internet_id?
    stubbing_enabled? && ENV.has_key?('STUB_INTERNET_ID')
  end

  def self.stubbing_enabled?
    File.exist?(ENABLE_STUB_FILE) &&
      File.read(ENABLE_STUB_FILE).strip == "I Want To Stub"
  end

  def self.stub_internet_id
    if using_stub_internet_id?
      ENV['STUB_INTERNET_ID'] || ENV['STUB_X500']
    else
      raise "Boom" # TODO redefine this guy raise StubX500Notset, "Dont call this method without doing UmnAuth.using_stub_x500? first"
    end
  end

  @@session_stub = nil
  def self.session_stub
    if @@session_stub.nil?
    end
    @@session_stub
  end

  self.set_global_defaults!
end
