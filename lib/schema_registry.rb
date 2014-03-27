require 'forwardable'
require 'multi_json'

class SchemaRegistry
  extend Forwardable

  def initialize(schema_glob)
    @schema_glob = schema_glob
  end

  def_delegators :all, :fetch

  def all
    Dir.glob(@schema_glob).reduce({}) do |schemas, filepath|
      schema = MultiJson.load(File.read(filepath))
      schemas.merge(schema.fetch("slug") => schema)
    end
  end
end
