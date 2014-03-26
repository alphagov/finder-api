require "spec_helper"

require "elastic_search_repository"

describe ElasticSearchRepository do
  subject(:repo) {
    ElasticSearchRepository.new(
      http_client,
      namespace,
      finder_type,
    )
  }

  let(:http_client)      { double(:http_client, get: nil, post: nil) }
  let(:namespace)        { "test-namespace" }
  let(:finder_type)      { "test-finder-type" }

  describe "#find_by" do
    let(:criteria) { {} }

    let(:search_result) { double(:search_result) }

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

    before do
      allow(http_client).to receive(:post).and_return(response)
    end

    it "POSTs to the ES search endpoint" do
      repo.find_by(criteria)

      expect(http_client).to have_received(:post)
        .with("/#{namespace}/_search", anything)
    end

    it "returns the results unwrapping the extraneous ES fields" do
      expect(repo.find_by(criteria)).to eq([search_result])
    end

    context "when the criteria is a single string match" do
      let(:criteria) {
        {
          "case_state" => "open",
        }
      }

      let(:es_term_query) {
        {
          "filter" => {
            "and" => {
              "filters" => [
                {
                  "terms" => { "case_state" => ["open"] }
                }
              ]
            }
          }
        }
      }

      it "translates the criteria hash into ES compatible params" do
        repo.find_by(criteria)

        expect(http_client).to have_received(:post)
          .with(anything, MultiJson.dump(es_term_query))
      end
    end

    context "when criteria contains a date field" do
      let(:criteria) {
        {
          "opened_date" => "2006",
        }
      }

      let(:es_range_query) {
        {
          "filter" => {
            "and" => {
              "filters" => [
                "or" => {
                  "filters" => [
                    {
                      "range" => {
                        "opened_date" => {
                          "from" => "2006-01-01",
                          "to" => "2006-12-31",
                        }
                      }
                    }
                  ]
                }
              ]
            }
          }
        }
      }

      it "translates the criteria hash into ES compatible range query" do
        repo.find_by(criteria)

        expect(http_client).to have_received(:post)
          .with(anything, MultiJson.dump(es_range_query))
      end
    end

    context "when criteria multiple fields" do
      it "translates the criteria hash into an ES query"
    end

    context "when criteria contains a field with more than one value" do
      it "translates the criteria hash into an ES query"
    end
  end

  describe "#store" do
    it "posts the case data to the ES endpoint"
  end
end
