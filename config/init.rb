# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm :datamapper
use_test :rspec
use_template_engine :haml
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '01500e35fb47beb929f1e1fbd0024a13d6fe8d10'  # required for cookie session store
  c[:session_id_key] = '_yak_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
  Merb::Slices::config[:merb_auth_slice_activation].merge!({
    :from_email => 'no-reply@yak.s21g.com',
    :activation_host => "localhost:#{Merb.config[:port]}"
  })

  Merb::Mailer.config = {
    :sendmail_path => '/usr/sbin/sendmail'
  }
  Merb::Mailer.delivery_method = :sendmail
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end
