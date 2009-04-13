class Person
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :size => 255
  property :email, String, :size => 255
  property :created_at, Time

  has n, :yaks

#  validates_present :login, :email
#  validates_length :login, :min => 4
#  validates_length :password, :min => 4, :allow_nil => true
#  validates_is_unique :login
#  validates_format :email, :as => :email_address

  def self.desc
    all(:order => [:created_at.desc])
  end
end
