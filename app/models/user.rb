class User
  include DataMapper::Resource
  
  property :id, Serial
  property :nickname, String, :size => 255
  property :email, String, :size => 255
end if Merb.env != 'production'
