class User
  include DataMapper::Resource
  
  property :id, Serial
  property :nickname, String, :size => 255
  property :email, String, :size => 255

  class << self
    def validates_present(*args) end
    def validates_is_confirmed(*args) end
  end
end if Merb.env != 'production'
