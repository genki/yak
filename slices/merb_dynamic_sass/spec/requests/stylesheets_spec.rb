require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
require "pp"

describe "GET /stylesheets/filepath.css" do

  before(:all) do
    mount_slice
    @store = MerbDynamicSass.action_cache_store
    @file =  MerbDynamicSass.dir_for(:view) / :stylesheets / "basic.css.erb"
    
    # This direcotry is necessary for this test.
    template_dir = MerbDynamicSass.dir_for(:view) / :stylesheets
    unless File.directory? template_dir
      FileUtils.mkdir_p template_dir
    end

    # Create a template file
    @store.send :write_file, @file, <<-CONTENT
h1
  color: red
    CONTENT
  end

  after(:all) do
    FileUtils.rm @file
    MerbDynamicSass.action_cache_store.delete("basic.css")
  end

  unless Merb::Slices.config[:merb_dynamic_sass][:page_cache]

  it "should be successful and return a appropriate content-type header." do
    response = request("/stylesheets/basic.css")
    response.status.should be_successful
    response.headers["Content-Type"].should == "text/css"

    # doing twice to see the case when the cached file is exists.
    response = request("/stylesheets/basic.css")
    response.status.should be_successful
    response.headers["Content-Type"].should == "text/css"
  end


  it "should let Stylesheets controller to receive filename" do
    request_to("/stylesheets/some.css")[:path].should == "some"
  end

  it "should recognize filepath of requested stylesheets" do
    request_to("/stylesheets/some_dir/some.css")[:path].should == "some_dir/some"
  end

  it "should cache generated stylesheets" do
    response = request("/stylesheets/basic.css")
    MerbDynamicSass.action_cache_store.should be_exists("basic.css")
  end

  it "should not use cahce if template is modified" do
    store = @store
    file =  MerbDynamicSass.dir_for(:view) / :stylesheets / "modify.css.erb"

    # Create a template file
    store.send :write_file, file, <<-CONTENT
h1
  color: red
    CONTENT

    # Caching
    response = request("/stylesheets/modify.css")
    response.should be_successful
    store.exists?("modify.css").should == true
    first_cache_modified_time = File.mtime(store.pathify("modify.css"))
    store.read("modify.css").should include("color: red")

    # Cached result should be used.
    response = request("/stylesheets/modify.css")
    response.should be_successful
    File.mtime(store.pathify("modify.css")).should == first_cache_modified_time 

    sleep(2)

    # Modify
    store.send :write_file, file, <<-CONTENT
h1
  color: green
    CONTENT

    # Caching again
    response = request("/stylesheets/modify.css")
    response.should be_successful
    store.exists?("modify.css").should == true
    second_cache_modified_time = File.mtime(store.pathify("modify.css"))
    second_cache_modified_time.should > first_cache_modified_time
    store.read("modify.css").should include("color: green")

    store.delete("modify.css")
    FileUtils.rm(file)

  end


  else

  it "should have cache under Merb.root/:public if you need" do
    Merb::Slices::config[:merb_dynamic_sass][:page_cache] = true
    uri = "/stylesheets/basic.css"
    response = request(uri, "REQUEST_URI" => uri)
    response.status.should be_successful
    response.headers["Content-Type"].should == "text/css"
    cachefile = Merb.root_path( :public / :stylesheets / "basic.css" )
    File.exists?(cachefile).should == true
    FileUtils.rm(cachefile)
    Merb::Slices::config[:merb_dynamic_sass][:page_cache] = false
  end

  end
    
  
end
