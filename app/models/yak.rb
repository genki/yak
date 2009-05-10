class Yak
  include DataMapper::Resource
  
  property :id, Serial
  property_with_spec :name, String, :size => 255 do
    should be_present
  end
  property :state, String
  property :created_at, Time

  belongs_to :yak
  has n, :yaks
end
