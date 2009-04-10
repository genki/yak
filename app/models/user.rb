# This is a default user class used to activate merb-auth.  Feel free to change from a User to 
# Some other class, or to remove it altogether.  If removed, merb-auth may not work by default.
#
# Don't forget that by default the salted_user mixin is used from merb-more
# You'll need to setup your db as per the salted_user mixin, and you'll need
# To use :password, and :password_confirmation when creating a user
#
# see merb/merb-auth/setup.rb to see how to disable the salted_user mixin
# 
# You will need to setup your database and create a user.
class User
  include DataMapper::Resource
  include Merb::Authentication::Mixins::ActivatedUser
  
  property :id, Serial
  property :login, String, :size => 255, :unique_index => true
  property :email, String, :size => 255, :unique_index => true

  has n, :yaks

  validates_present :login, :email
  validates_length :login, :min => 4
  validates_length :password, :min => 4, :allow_nil => true
  validates_is_unique :login
  validates_format :email, :as => :email_address

  def self.active
    all(:activated_at.not => nil)
  end

  def self.desc
    all(:order => [:id.desc])
  end
end
