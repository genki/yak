require File.dirname(__FILE__) + '/spec_helper'

describe "MerbDynamicSass (module)" do
  
  describe "with Merb::Cache" do

    it "has self.action_cache_store and self.page_cache_store" do
      MerbDynamicSass.action_cache_store.should be_a(Merb::Cache::FileStore)
      MerbDynamicSass.page_cache_store.should be_a(Merb::Cache::PageStore)
    end

    it "has the store for action cache whose dir is Merb.root/:tmp/:cache/:stylesheets" do
      store = MerbDynamicSass.action_cache_store
      store.dir.should == (Merb.root_path(:tmp/:cache/:stylesheets))
      store.pathify("basic.css").should == (Merb.root_path(:tmp/:cache/:stylesheets/ "basic.css"))
      store.pathify("somedir/basic.css").should == (Merb.root_path(:tmp/:cache/:stylesheets/:somedir/"basic.css"))
    end

    it "has the store for page cache whose dir is Merb.root/:public" do
      store = MerbDynamicSass.page_cache_store.stores.first
      store.dir.should == (Merb.root/:public)
    end

  end
  
end

