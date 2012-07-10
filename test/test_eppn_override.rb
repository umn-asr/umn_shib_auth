require 'helper'

class TestEppnOverride < Test::Unit::TestCase
  context "A proxied shib app" do
    setup do
      @eppn_var = 'HTTP_EPPN'
      @internet_id = 'asdf'
      @eppn = "#{@internet_id}@blah.edu"
      UmnShibAuth.eppn_variable = @eppn_var
      @controller = DummyController.new
      @controller.stubs(:request => stub(:env => {@eppn_var => @eppn}))
    end
    should "override default eppn var" do
      assert_kind_of(UmnShibAuth::Session, @controller.shib_umn_session, "Failed to create a session")
      assert_equal(@controller.shib_umn_session.internet_id, @internet_id, "Didn't parse internet ID correctly")
    end
  end
end
