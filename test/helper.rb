require 'rubygems'
require 'active_support/core_ext'
require 'action_controller'
require 'test/unit'
require 'shoulda'
require 'umn_shib_auth'

class DummyController < ActionController::Base
  include UmnShibAuth::ControllerMethods
end
