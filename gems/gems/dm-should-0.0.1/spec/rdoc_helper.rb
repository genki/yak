module Spec::Example::RdocHelper
  def h4(title, option={}, &block)
    describe "\n==== #{title}", option, &block 
  end
end

def h3(title, option={}, &block)
  describe "=== #{title}", option, &block 
end

def h4(title, option={}, &block)
  describe "==== #{title}", option, &block 
end

class Spec::Example::ExampleGroup
  extend Spec::Example::RdocHelper
end
