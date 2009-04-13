module BeeU
  #class User
  #  #include Bumble
  #  include DataMapper::Resource
#
 #   property :nickname, String
  #  property :email, String, :size => 255
  #end

  class << self
    def login(url)
      Merb::Router.url(:login)
    end
 
    def logout(url)
      Merb::Router.url(:logout)
    end
  end
  
  module InstanceMethods
  protected
    def assign_user
      @user = session.user
    end
 
    def assign_admin_status
      #@admin = US::Service.user_logged_in? && US::Service.user_admin?
    end
    
    def verify_admin_user
      #unless US::Service.user_logged_in? && US::Service.user_admin?
      #  if US::Service.user_logged_in?
      #    render :text => "You are not allowed to do that"
      #  else
      #    redirect_to US::Service.create_login_url(request.url)
      #  end
      #end
    end
  end
 
  module ClassMethods
    def require_admin(*actions)
      before :verify_admin_user, :only => actions
    end
  end
 
  def self.included(base)
    #unless @initialized
    #  require File.join(Merb.root ,%w(merb merb-auth setup))
    #  @initialized = true
    #end
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
end
