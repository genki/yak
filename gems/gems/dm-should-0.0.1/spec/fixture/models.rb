# models for everything, especially used in dm-should_spec.rb  
class Item
  include DataMapper::Resource 

  property :id, Serial
  property_with_spec :name, String do
    should be_present
  end

end

class Item2
  include DataMapper::Resource 

  property :id, Serial
  property_with_spec :name, String do
    should be_present
  end
  property_with_spec :price, Integer do
    should be_present
  end

end


# models for testing specdoc generation
class SpecDoc1
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, String do
    should be_present
    should be_unique
    should be_positive_integer
  end

end

class SpecDoc2
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, Integer, :nullable => false do
    should be_present
    should be_unique
    should be_positive_integer
  end
  property_with_spec :number2, Integer do
    should be_present
    should be_unique
    should be_positive_integer
  end

end


# models for testing each spec classes. 
class BePresent1
  include DataMapper::Resource 

  property :id, Serial
  property_with_spec :name, String do
    should be_present
  end

end

class BePresent2
  include DataMapper::Resource
  property :id, Serial
  property_with_spec :number, Integer do
    should be_present
  end
end

class BePositiveInteger1
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, Integer do
    should be_positive_integer
  end
end

# when :allow => nil
class BePositiveInteger2
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, Integer, :nullable => false do
    should be_positive_integer
  end
end

class BeUnique1
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, Integer do
    should be_unique
  end

end

class BeUnique2
  include DataMapper::Resource
  
  property :id, Serial
  property :category, String
  property_with_spec :number, Integer do
    should be_unique(:scope => :category)
  end

end

class Match1
 include DataMapper::Resource 

 property :id, Serial
 property_with_spec :name, String do
   should match(/^A/)
 end
end


