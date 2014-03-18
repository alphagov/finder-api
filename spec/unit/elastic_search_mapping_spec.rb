require "spec_helper"

require "multi_json"
require "elastic_search_mapping"

describe ElasticSearchMapping do
  subject(:mapping) { ElasticSearchMapping.new(schema) }

  let(:schema) {
    MultiJson.load(File.read("spec/fixtures/schemas/cma-cases.json"))
  }

  let(:facets) {
    ["case_type", "case_state", "market_sector", "outcome_type"]
  }

  describe "#to_hash" do
    it "returns a mapping containing all facets" do
      mapping_properties = mapping.to_hash.fetch("cma-cases-test").fetch("properties")

      expect(mapping_properties.keys).to match_array(facets)
    end

    it "maps all facets to string type (until we know more about the schema)" do
      mapping_properties = mapping.to_hash.fetch("cma-cases-test").fetch("properties")

      mapping_properties.each do |_, attributes|
        expect(attributes['type']).to eq('string')
      end
    end

    it "sets everything to not_analyzed (as we have no body fields)"do
      mapping_properties = mapping.to_hash.fetch("cma-cases-test").fetch("properties")

      mapping_properties.each do |_, attributes|
        expect(attributes['index']).to eq('not_analyzed')
      end
    end
  end
end
