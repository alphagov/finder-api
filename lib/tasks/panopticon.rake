namespace :panopticon do
  desc "Register all finders with panopticon"
  task :register do
    require "application"
    require "registerables"
    require 'panopticon_registerer'
    require "config/initializers/elasticsearch.rb"
    require 'config/initializers/panopticon_api_credentials.rb'

    require "multi_json"

    registerables = Dir.glob("metadata/**/*.json").map do |file_path|
      metadata = MultiJson.load(File.read(file_path))

      [
        Registerables::Schema.new(metadata),
      ]
    end

    PanopticonRegisterer.register(registerables.flatten)
  end
end
