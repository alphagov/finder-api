namespace :panopticon do
  desc "Register all finders with panopticon"
  task :register do
    require 'schema_registry'
    require 'panopticon_registerer'
    require 'config/initializers/panopticon_api_credentials.rb'

    SchemaRegistry.new.all.each do |slug, schema|
      PanopticonRegisterer.register(schema)
    end
  end
end