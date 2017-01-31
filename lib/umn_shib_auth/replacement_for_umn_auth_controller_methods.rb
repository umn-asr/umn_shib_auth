module UmnShibAuth
  module ReplacementForUmnAuthControllerMethods
    def self.included(caller)
      caller.class_eval do
        include UmnShibAuth::ControllerMethods
        helper_method :login_and_redirect_url, :logout_and_redirect_url, :logout_url, :current_umn_session
      end
    end

    def login_and_redirect_url(redirect_url = nil)
      shib_login_and_redirect_url(redirect_url)
    end

    def logout_and_redirect_url(redirect_url = nil)
      shib_logout_and_redirect_url(redirect_url)
    end

    def logout_url
      shib_logout_url
    end

    def current_umn_session
      shib_umn_session
    end

    def umn_auth_required
      shib_umn_auth_required
    end
  end
end
