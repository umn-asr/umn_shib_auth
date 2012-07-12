module UmnShibAuth
  module ControllerMethods
    def self.included(controller)
      controller.class_eval do
        helper_method :shib_login_and_redirect_url, :shib_logout_and_redirect_url, :shib_logout_url, :shib_umn_session, :shib_debug_env_vars
      end
      if UmnShibAuth.using_stub_internet_id?
        puts "[umn_shib_auth] ENV['STUB_INTERNET_ID'] detected, shib_umn_session will be stubbed with internet_id=#{UmnShibAuth.stub_internet_id} for all requests.
              You can also hit this in the console via UmnShibAuth.session_stub
        "
      end
    end

    def shib_umn_session
      if UmnShibAuth.using_stub_internet_id?
        @shib_umn_session ||= UmnShibAuth::Session.new(:eppn => UmnShibAuth.stub_internet_id)
      else
        if request.env[UmnShibAuth.eppn_variable].blank?
          @shib_umn_session = nil
        else
          @shib_umn_session ||= UmnShibAuth::Session.new(:eppn => request.env[UmnShibAuth.eppn_variable])
        end
      end
      @shib_umn_session
    end

    ###############
    # URL HELPERS #
    ###############
    def shib_login_and_redirect_url(redirect_url=nil)
      redirect_url ||= request.url
      encoded_redirect_url = ERB::Util.url_encode(redirect_url)
      "https://#{request.host}/Shibboleth.sso/Login?target=#{encoded_redirect_url}"
    end
 
    def shib_logout_url
      if request.env['Shib-Identity-Provider'].to_s.match(/idp-test.shib.umn.edu/)
        redirect_url='https://idp-test.shib.umn.edu/idp/LogoutUMN'
      else
        redirect_url='https://idp2.shib.umn.edu/idp/LogoutUMN'
      end
      encoded_redirect_url = ERB::Util.url_encode(redirect_url)
      "https://#{request.host}/Shibboleth.sso/Logout?return=#{encoded_redirect_url}"
    end

    # Warning: This function is dangerous,
    # use shib_logout_url if you can.
    #
    def shib_logout_and_redirect_url(redirect_url=nil)
      logger.warn "WARNING: shib_logout_and_redirect_url is a dangerous function with Shibboleth because it does not log the user out of the IDP, consider using shib_logout_url"
      redirect_url ||= request.url
      encoded_redirect_url = ERB::Util.url_encode(redirect_url)
      "https://#{request.host}/Shibboleth.sso/Logout?return=#{encoded_redirect_url}"
    end
    
    # This is a before_filter designed to replace the :umn_auth_required
    # from the x500 UmnAuth tool. 
    # Since we are expecting the web server to be propogating the logged in user variable
    # this simply tells the user that there was an error.
    # Its a safety precaution
    #
    def shib_umn_auth_required
      return true if UmnShibAuth.using_stub_internet_id?
      if shib_umn_session.nil?
        redirect_to shib_login_and_redirect_url and return false
      else
        return true
      end
    end

    def shib_debug_env_vars
      s='<ul>'
      request.env.each_pair do |key,val|
        s += "<li><strong>#{key}:</strong> #{val}</li>"
      end 
      s+='</ul>'
      s
    end

  end
end
