require "spec_helper"

require "elastic_search_repository"

describe ElasticSearchRepository do
  subject(:repo) {
    ElasticSearchRepository.new(
      http_client,
      query_builder,
      namespace,
    )
  }

  let(:http_client)      { double(:http_client, put: nil, post: nil, delete: nil) }
  let(:namespace)        { "test-namespace" }
  let(:query_builder)    { double(:query_builder) }

  describe "#find_by" do
    let(:criteria) { double(:criteria) }
    let(:finder_type) { double(:finder_type) }
    let(:query) { double(:query) }

    let(:response) { double(:reponse, body: body) }
    let(:body) {
      # ElasticSearch really does return results like this :P
      {
        "hits" => {
          "hits" => [
            {
              "_source" => search_result,
            },
          ]
        }
      }
    }
    let(:search_result) { double(:search_result) }

    before do
      allow(http_client).to receive(:post).and_return(response)
      allow(query_builder).to receive(:call).and_return(query)
    end

    it "builds an elastic search compatible query" do
      repo.find_by(finder_type, criteria)

      expect(query_builder).to have_received(:call).with(criteria)
    end

    it "POSTs to the ES search endpoint" do
      repo.find_by(finder_type, criteria)

      expect(http_client).to have_received(:post)
        .with("/#{namespace}/#{finder_type}/_search?size=1000", query)
    end

    it "returns the results unwrapping the extraneous ES fields" do
      expect(repo.find_by(finder_type, criteria)).to eq([search_result])
    end
  end

  describe "#store" do
    let(:slug) { "document_finder_type/document_title_slug" }
    let(:document_data) { double(:document_data) }

    it "PUTs the document data to the ES endpoint" do
      repo.store(slug, document_data)

      expect(http_client).to have_received(:put)
        .with("/#{namespace}/#{slug}", document_data)
    end
  end

  describe "#delete" do
    let(:slug) { "document_finder_type/document_title_slug" }

    it "DELETEs the document data to the ES endpoint" do
      repo.delete(slug)

      expect(http_client).to have_received(:delete)
        .with("/#{namespace}/#{slug}")
    end
  end

end
