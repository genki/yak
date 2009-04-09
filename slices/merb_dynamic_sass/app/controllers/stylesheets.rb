class MerbDynamicSass::Stylesheets < MerbDynamicSass::Application
  provides :css
  layout false

  self._template_roots << [Merb.dir_for(:view), :_dynamic_sass_template_location]
  def _dynamic_sass_template_location(context, type, controller)
    _template_location(@template_path, type, "stylesheets")
  end
  private :_dynamic_sass_template_location

  def _slice_template_location(context, type = nil, controller = controller_name)
    super(@template_path, type, controller)
  end
  private :_slice_template_location

  def self.page_cache?
    Merb::Slices.config[:merb_dynamic_sass][:page_cache]
  end

  if page_cache?
    cache :index, :store => MerbDynamicSass.page_cache_store_name
  end


  def index(path)
    @template_path = path
    if self.slice.action_cache_store.exists?(_cache_path)

      m_template = File.mtime _location_of_template
      m_cache = File.mtime _location_of_cache

      if m_template > m_cache
        self.slice.action_cache_store.delete _cache_path
      end

    end

    self.content_type = :css
    self.slice.action_cache_store.fetch _cache_path do
      sass = render(:format => :css)
      Sass::Engine.new(sass).to_css
    end
  end

  def _cache_path
    "#{@template_path}.css"
  end
  private :_cache_path

  def _location_of_template
    file = nil
    self.class._template_roots.reverse_each do |root, template_method|
      f =  root / self.send(template_method, @template_path, :css, nil)
      file = "#{f}.erb" and break if File.exists?("#{f}.erb")
    end
    file
  end
  private :_location_of_template

  def _location_of_cache
    self.slice.action_cache_store.pathify _cache_path
  end
  private :_location_of_cache

end
