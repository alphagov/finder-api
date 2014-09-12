namespace :panopticon do
  desc "Register all finders with panopticon"
  task :register do
    require "application"
    require 'panopticon_registerer'
    require "config/initializers/elasticsearch.rb"
    require 'config/initializers/panopticon_api_credentials.rb'

    require "multi_json"

    metadata = Dir.glob("metadata/**/*.json").map do |file_path|
      MultiJson.load(File.read(file_path))
    end

    PanopticonRegisterer.register(metadata)
  end
end
