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

  describe "shib_logout_url" do
    let(:controller)  { DummyController.new }
    let(:host)        { "example.com"}

    before do
      request_double = double('request_double', env: {"Shib-Identity-Provider" => shib_identity_provider})
      allow(controller).to receive(:request).and_return(request_double)
      allow(request_double).to receive(:host).and_return(host)
    end

    context "test IDP" do
      let(:shib_identity_provider) { "login-test.umn.edu" }

      it "returns encoded test logout URL" do
        expect(controller.shib_logout_url).to eq "https://#{host}/Shibboleth.sso/Logout?return=https%3A%2F%2F#{ shib_identity_provider }%2Fidp%2Fprofile%2FLogout"
      end
    end
    context "production IDP" do
      let(:shib_identity_provider) { "login.umn.edu" }

      it "returns encoded production logout URL" do
        expect(controller.shib_logout_url).to eq "https://#{host}/Shibboleth.sso/Logout?return=https%3A%2F%2F#{ shib_identity_provider }%2Fidp%2Fprofile%2FLogout"
      end
    end
  end
end
