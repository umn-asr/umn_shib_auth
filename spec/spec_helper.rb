require 'active_support/dependencies/autoload'
require 'action_controller'
require 'umn_shib_auth'
require 'logger'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
  config.order = :random
  Kernel.srand config.seed
end

class Rails
  class << self
    attr_accessor :logger, :env
  end
end

Rails.logger = Logger.new("/dev/null")
Rails.env = "test"

class DummyController < ActionController::Base
  include UmnShibAuth::ControllerMethods

  # In a real Rails app that has a root route defined, this method exists
  # But in our test setup, we don't have have this part of Rails configured.
  # Rspec won't let us double a method that doesn't exist
  # So we make this method exist just for our test controller
  def root_path; end
end
