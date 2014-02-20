def ensure_load_path_has(path)
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end

app_path = File.dirname(__FILE__)
ensure_load_path_has(app_path)
ensure_load_path_has(app_path + "/lib")

require './finder_api.rb'
run FinderApi
