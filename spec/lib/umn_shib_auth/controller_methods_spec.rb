require_relative "../../spec_helper"

RSpec.describe UmnShibAuth::ControllerMethods do
  let(:request_double) { instance_double(ActionDispatch::Request) }
  let(:controller)  { DummyController.new }
  let(:eppn_var)    { 'HTTP_EPPN' }
  let(:internet_id) { 'asdf' }
  let(:eppn)        { "#{internet_id}@blah.edu" }
  let(:env_double)  { { eppn_var => eppn } }

  before do
    UmnShibAuth.eppn_variable = eppn_var
    allow(request_double).to receive(:xml_http_request?).and_return(false)
  end

  describe "A proxied shib app" do
    before do
      allow(request_double).to receive(:env).and_return(env_double)
      allow(controller).to receive(:request).and_return(request_double)
    end

    it "overrides default eppn var" do
      expect(controller.shib_umn_session).to be_kind_of(UmnShibAuth::Session)
      expect(controller.shib_umn_session.internet_id).to eq internet_id
    end
  end

  describe "shib_logout_url" do
    let(:host) { "example.com" }

    before do
      allow(request_double).to receive(:env).and_return("Shib-Identity-Provider" => shib_identity_provider)
      allow(controller).to receive(:request).and_return(request_double)
      allow(request_double).to receive(:host).and_return(host)
    end

    context "test IDP" do
      let(:shib_identity_provider) { "login-test.umn.edu" }

      it "returns encoded test logout URL" do
        expect(controller.shib_logout_url).to eq "https://#{host}/Shibboleth.sso/Logout?return=https%3A%2F%2F#{shib_identity_provider}%2Fidp%2Fprofile%2FLogout"
      end
    end
    context "production IDP" do
      let(:shib_identity_provider) { "login.umn.edu" }

      it "returns encoded production logout URL" do
        expect(controller.shib_logout_url).to eq "https://#{host}/Shibboleth.sso/Logout?return=https%3A%2F%2F#{shib_identity_provider}%2Fidp%2Fprofile%2FLogout"
      end
    end
  end

  describe "shib_umn_auth_required" do
    context "A stub internet id is in use" do
      before do
        allow(UmnShibAuth).to receive(:using_stub_internet_id?).and_return(true)
      end

      it "returns true" do
        expect(controller.shib_umn_auth_required).to be_truthy
      end
    end

    context "A stub internet id is not in use" do
      before do
        allow(UmnShibAuth).to receive(:using_stub_internet_id?).and_return(false)
      end

      context "there is no shib_umn_session" do
        before do
          allow(request_double).to receive(:url).and_return("https://google.com")
          allow(request_double).to receive(:host).and_return("secret.umn.edu")
          allow(request_double).to receive(:env).and_return({})
          allow(controller).to receive(:request).and_return(request_double)
        end

        context "and the request is not an ajax request" do
          before do
            allow(request_double).to receive(:xml_http_request?).and_return(false)
            @login_url = "https://secret.umn.edu/Shibboleth.sso/Login?target=#{ERB::Util.url_encode('https://google.com')}"
          end

          it "redirects and returns false" do
            expect(controller).to receive(:redirect_to).with(@login_url)
            expect(controller.shib_umn_auth_required).to be_falsey
          end
        end

        context "and the request is an ajax request" do
          before do
            allow(request_double).to receive(:xml_http_request?).and_return(true)
            expect(controller).to receive(:root_path).and_return("https://app.umn.edu")
            @login_url = "https://secret.umn.edu/Shibboleth.sso/Login?target=#{ERB::Util.url_encode('https://app.umn.edu')}"
          end

          it "renders javascript that will change the window location to the correct shib login" do
            expect(controller).to receive(:render).with(js: "window.location.replace('#{@login_url}');")
            expect(controller.shib_umn_auth_required).to be_falsey
          end
        end
      end

      context "there is a shib_umn_session" do
        before do
          allow(request_double).to receive(:env).and_return(env_double)
          allow(controller).to receive(:request).and_return(request_double)
        end

        it "returns true" do
          expect(controller.shib_umn_auth_required).to be_truthy
        end
      end
    end
  end
end
