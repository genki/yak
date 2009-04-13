class Yak
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :size => 255
  property :state, String
  property :created_at, Time

  belongs_to :yak
  has n, :yaks
end
