$LOAD_PATH.unshift(File.expand_path("..", __FILE__))
$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require "finder_schema"
require "schema_registry"
require "adapters/null_adapter"

Dir.glob("services/*.rb").each { |f| require f }

class Application
  def initialize(env, schemas_glob: default_schemas_glob)
    @schemas_glob = schemas_glob
  end

private

  attr_reader(
    :schemas_glob,
  )

  def schema(finder_type)
    schemas.fetch(finder_type)
  end

  def schemas
    Hash[
      SchemaRegistry.new(schemas_glob).all.map { |slug, schema|
        [slug, FinderSchema.new(schema)]
      }
    ]
  end

  def default_schemas_glob
    "schemas/**/*.json"
  end
end
