namespace :panopticon do
  task :register do
    require 'schema_registry'
    require 'panopticon_registerer'

    SchemaRegistry.new.all.each do |slug, schema|
      PanopticonRegisterer.register(schema)
    end
  end
end