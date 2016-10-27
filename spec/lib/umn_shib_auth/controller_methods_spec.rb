require_relative "../../spec_helper"

RSpec.describe UmnShibAuth::ControllerMethods do
  describe "A proxied shib app" do
    let(:eppn_var)    { 'HTTP_EPPN' }
    let(:internet_id) { 'asdf' }
    let(:eppn)        { "#{internet_id}@blah.edu" }
    let(:controller)  { DummyController.new }

    before do
      UmnShibAuth.eppn_variable = eppn_var
      request_double = double('request_double', env: {eppn_var => eppn})
      allow(controller).to receive(:request).and_return(request_double)
    end

    it "overrides default eppn var" do
      expect(controller.shib_umn_session).to be_kind_of(UmnShibAuth::Session)
      expect(controller.shib_umn_session.internet_id).to eq internet_id
    end
  end

end
