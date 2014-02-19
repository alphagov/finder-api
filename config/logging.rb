before {
  error_log_file = File.expand_path("../log/production.log", File.dirname(__FILE__))
  error_log = File.open(error_log_file, 'a+')
  error_log.sync = true
  env['rack.errors'] = error_log
}
