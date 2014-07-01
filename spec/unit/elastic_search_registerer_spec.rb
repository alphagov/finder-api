require "spec_helper"

require "multi_json"
require "elastic_search_registerer"

describe ElasticSearchRegisterer do
  subject(:registerer) { ElasticSearchRegisterer.new(http_client, namespace) }

  let(:http_client) { double(:http_client, put: nil) }
  let(:namespace) { "finder-api-test-namespace" }

  let(:mapping_hash) { {some_key: 'some_value'} }
  let(:mapping) {
    double(:elastic_search_mapping,
      to_h: mapping_hash,
      finder_slug: 'cma-cases'
    )
  }
  let(:index_path) { "/#{namespace}" }

  describe "#store(elastic_search_mapping)" do
    let(:mapping_path) { "#{index_path}/cma-cases/_mapping" }
    let(:json_mapping) { MultiJson.dump(mapping_hash) }

    it "sends the json-encoded mapping to ES" do
      registerer.store_map(mapping)
      expect(http_client).to have_received(:put).with(mapping_path, json_mapping)
    end
  end

  describe "#create_index" do
    it "creates the index" do
      registerer.create_index
      expect(http_client).to have_received(:put)
        .with(index_path, hash_including("settings"))
    end
  end
end
