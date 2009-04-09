if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices', :immediate => true
  Merb::Plugins.add_rakefiles "merb_dynamic_sass/merbtasks", "merb_dynamic_sass/slicetasks", "merb_dynamic_sass/spectasks"

  # Register the Slice for the current host application
  # * This slice is not intended to be used in production environment
  Merb::Slices::register(__FILE__)# unless Merb.environment == "production"
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merb_dynamic_sass
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_dynamic_sass][:layout] ||= :merb_dynamic_sass
  
  # All Slice code is expected to be namespaced inside a module
  module MerbDynamicSass
    
    # Slice metadata
    self.description = "MerbDynamicSass is a slice to provide more handy way to use Sass engine."
    self.version = "0.0.1"
    self.author = "Yukiko Kawamoto"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    # * use @initialized because sometimes self.init is called twice,
    #   especially during the spec or rake process.
    attr_reader :initialized
    def self.init
      unless @initialized
        require "sass"
        # route is automatically prepared.
        Merb::Router.prepare [], Merb::Router.routes do
          slice(:merb_dynamic_sass, :name_prefix => nil)
        end
        Merb.add_mime_type(:css, :to_css, %w[text/css])
        Merb.cache.register(action_cache_store_name, Merb::Cache::FileStore, :dir => Merb.root_path( :tmp / :cache / :stylesheets ))
        Merb.cache.register(page_cache_store_name, Merb::Cache::PageStore[Merb::Cache::FileStore], :dir => Merb.root_path( "public" ))
        @initialized = true
      end
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbDynamicSass)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_dynamic_sass_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      scope.match(%r{^/stylesheets/(.*)\.css$}).to(:controller => "stylesheets", :action => "index", :path => "[1]").name :css
    end

    def self.action_cache_store_name
      :dynamic_sass_action_cache
    end

    def self.page_cache_store_name
      :dynamic_sass_page_cache
    end

    def self.action_cache_store
      Merb::Cache[action_cache_store_name]
    end

    def self.page_cache_store
      Merb::Cache[page_cache_store_name]
    end

  end
  
  # Setup the slice layout for MerbDynamicSass
  #
  # Use MerbDynamicSass.push_path and MerbDynamicSass.push_app_path
  # to set paths to merb_dynamic_sass-level and app-level paths. Example:
  #
  # MerbDynamicSass.push_path(:application, MerbDynamicSass.root)
  # MerbDynamicSass.push_app_path(:application, Merb.root / 'slices' / 'merb_dynamic_sass')
  # ...
  #
  # Any component path that hasn't been set will default to MerbDynamicSass.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbDynamicSass.setup_default_structure!
  
  # Add dependencies for other MerbDynamicSass classes below. Example:
  # dependency "merb_dynamic_sass/other"
  dependency "merb-cache"
  dependency "merb-action-args"
  
end
