def ensure_load_path_has(path)
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end

app_path = File.dirname(__FILE__)
ensure_load_path_has(app_path)
ensure_load_path_has(app_path + "/lib")

Dir.glob(app_path  + '/lib/tasks/*.rake').each do |r|
  import r
end

task :default => [:spec, :cucumber]
