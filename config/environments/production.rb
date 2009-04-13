Merb.logger.info("Loaded PRODUCTION Environment...")
Merb::Config.use { |c|
  c[:exception_details] = false
  c[:reload_classes] = false
  c[:log_level] = :error
  
  c[:log_file]  = Merb.root / "log" / "production.log"
  # or redirect logger using IO handle
  c[:log_stream] = STDOUT
}

Merb::BootLoader.before_app_loads do
  Merb::Slices::config[:merb_auth_slice_activation].merge!({
    :from_email => 'no-reply@yak.s21g.com',
    :activation_host => "yak.s21g.com"
  })
end
