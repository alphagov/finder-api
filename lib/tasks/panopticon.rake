namespace :panopticon do
  desc "Register all finders with panopticon"
  task :register do
    require "application"
    require 'panopticon_registerer'
    require 'config/initializers/panopticon_api_credentials.rb'

    app = Application.new(ENV)

    app.send(:schemas).each do |slug, schema|
      PanopticonRegisterer.register(schema)
    end
  end
end
