class Yak
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :size => 255
  property :state, String
  property :created_at, DateTime

  belongs_to :user

  belongs_to :yak
  has n, :yaks
end
