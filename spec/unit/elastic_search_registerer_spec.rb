require "spec_helper"

require "multi_json"
require "elastic_search_registerer"

describe ElasticSearchRegisterer do
  subject(:registerer) { ElasticSearchRegisterer.new(http_client) }

  let(:mapping_hash) { {some_key: 'some_value'} }
  let(:mapping) {
    double(:elastic_search_mapping,
      to_hash: mapping_hash,
      finder_slug: 'cma-cases'
    )
  }

  let(:http_client) { double(:http_client, put: nil) }

  describe "#store(elastic_search_mapping)" do
    let(:index_path) { "/finder-api" }
    let(:mapping_path) { "/finder-api/cma-cases/_mapping" }
    let(:json_mapping) { MultiJson.dump(mapping_hash) }

    it "creates the index" do
      registerer.store_map(mapping)
      expect(http_client).to have_received(:put).with(index_path)
    end

    it "sends the json-encoded mapping to ES" do
      registerer.store_map(mapping)
      expect(http_client).to have_received(:put).with(mapping_path, json_mapping)
    end
  end
end
