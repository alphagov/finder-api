require "spec_helper"

require "multi_json"
require "elastic_search_mapping"

describe ElasticSearchMapping do
  subject(:mapping) { ElasticSearchMapping.new(schema) }

  let(:schema) {
    MultiJson.load(File.read("spec/fixtures/schemas/cma-cases.json"))
  }

  let(:default_facets) {
    %w(
      title
      summary
      body
      updated_at
    )
  }

  let(:format_facets) {
    ["case_type", "case_state", "market_sector", "outcome_type"]
  }

  let(:all_facets) {
    default_facets + format_facets
  }

  describe "#to_h" do
    it "returns a mapping containing all facets" do
      mapping_properties = mapping.to_h.fetch("cma-cases").fetch("properties")

      expect(mapping_properties.keys).to match_array(all_facets)
    end

    it "sets format-specific facets to string type" do
      mapping_properties = mapping.to_h.fetch("cma-cases").fetch("properties").slice(format_facets)

      mapping_properties.each do |_, attributes|
        expect(attributes['type']).to eq('string')
      end
    end

    it "sets format-specific facets to not_analyzed"do
      mapping_properties = mapping.to_h.fetch("cma-cases").fetch("properties").slice(format_facets)

      mapping_properties.each do |_, attributes|
        expect(attributes['index']).to eq('not_analyzed')
      end
    end
  end
end
