require 'schema_registry'
require 'multi_json'

describe SchemaRegistry do
  let(:fixture_path) { File.dirname(__FILE__) + "/../fixtures/schemas/" }
  let(:fixture_file_data) { MultiJson.load(File.read(fixture_path + "/cma-cases.json")) }
  let(:schema_registry) { SchemaRegistry.new(fixture_path) }

  describe "#all" do
    it "loads all the schemas" do
      expect(schema_registry.all).to eq({ "cma-cases" => fixture_file_data })
    end
  end

  describe "#get" do
    it "gets the schema by slug" do
      expect(schema_registry.get('cma-cases')).to eq fixture_file_data
    end

    it "returns nil if no schema for that slug" do
      expect(schema_registry.get('non-existent')).to eq nil
    end
  end
end
