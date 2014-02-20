require 'multi_json'

class SchemaRegistry
  def initialize(schema_path = nil)
    @schema_path = schema_path || File.expand_path("../schemas", File.dirname(__FILE__))
  end

  def all
    Dir["#{@schema_path}/*.json"].map.with_object({}) do |path, all_schemas|
      filename = File.basename(path, '.json')
      all_schemas[filename] = MultiJson.load(File.read(path))
    end
  end

  def get(slug)
    all.fetch(slug, nil)
  end
end
