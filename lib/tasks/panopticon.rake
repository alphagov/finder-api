namespace :panopticon do
  desc "Register all finders with panopticon"
  task :register do
    require "application"
    require 'panopticon_registerer'
    require "config/initializers/elasticsearch.rb"
    require 'config/initializers/panopticon_api_credentials.rb'
    require 'config/initializers/better_errors.rb'

    app = Application.new(ENV)

    app.send(:schemas).each do |slug, schema|
      PanopticonRegisterer.register(schema.to_h)
    end
  end
end
