require 'forwardable'
require 'multi_json'

class SchemaRegistry
  extend Forwardable

  def initialize(schema_path)
    @schema_path = schema_path
  end

  def_delegators :all, :fetch

  def all
    Dir["#{@schema_path}/*.json"].map.with_object({}) do |path, all_schemas|
      filename = File.basename(path, '.json')
      all_schemas[filename] = MultiJson.load(File.read(path))
    end
  end
end
