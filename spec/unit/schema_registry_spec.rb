require 'schema_registry'
require 'multi_json'

describe SchemaRegistry do
  let(:fixture_glob) { File.dirname(__FILE__) + "/../fixtures/schemas/*.json" }
  let(:schema_registry) { SchemaRegistry.new(fixture_glob) }

  let(:fixture_file_data) {
    MultiJson.load(
      File.read(
        Dir.glob(fixture_glob).first
      )
    )
  }

  describe "#all" do
    it "loads all the schemas" do
      expect(schema_registry.all).to include({ "cma-cases" => fixture_file_data })
    end
  end

  describe "#fetch" do
    it "gets the schema by slug" do
      expect(schema_registry.fetch("cma-cases")).to eq fixture_file_data
    end

    it "returns nil if no schema for that slug" do
      expect(schema_registry.fetch("non-existent", nil)).to eq nil
    end
  end
end
