require 'java'
 
module BeeU
  module US
    unless const_defined?("Service")
      import com.google.appengine.api.users.UserServiceFactory
      Service = UserServiceFactory.user_service
    end
  end
 
  class << self
    def login(url)
      US::Service.create_login_url(url)
    end
 
    def logout(url)
      US::Service.create_logout_url(url)
    end
  end
  
  module InstanceMethods
    protected
    def assign_user
      if US::Service.user_logged_in?
        @user = US::Service.current_user
      end
    end
 
    def assign_admin_status
      @admin = US::Service.user_logged_in? && US::Service.user_admin?
    end

    def verify_admin_user
      unless US::Service.user_logged_in? && US::Service.user_admin?
        if US::Service.user_logged_in?
          render "You are not allowed to do that"
        else
          redirect US::Service.create_login_url(request.full_uri)
        end
      end
    end
  end
 
  module ClassMethods
    def require_admin(*actions)
      before :verify_admin_user, :only => actions
    end
  end
 
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
end
