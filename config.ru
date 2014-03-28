def ensure_load_path_has(path)
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end

app_path = File.dirname(__FILE__)
ensure_load_path_has(app_path)
ensure_load_path_has(app_path + "/lib")

if ENV['RACK_ENV'] == 'production'
  use Rack::Logstasher::Logger,
    Logger.new("log/production.json.log"),
    extra_request_headers: { "GOVUK-Request-Id" => "govuk_request_id", "x-varnish" => "varnish_id" }
end

require './finder_api.rb'
run FinderApi
