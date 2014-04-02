require "spec_helper"

require "elastic_search_query"

describe ElasticSearchQuery do
  subject(:query) {
    ElasticSearchQuery.new(criteria)
  }

  describe "#to_h" do
    let(:criteria) { {} }

    context "when the criteria contains a single filter" do
      let(:criteria) {
        {
          case_state: "open",
        }
      }

      let(:es_single_term_query) {
        {
          filter: {
            and: {
              filters: [
                {
                  terms: { case_state: ["open"] }
                }
              ]
            }
          }
        }
      }

      it "creates a single term filter" do
        expect(query.to_h).to eq(es_single_term_query)
      end
    end

    context "when criteria contains multiple fields and values" do
      let(:criteria) {
        {
          case_state: ["open", "closed"],
          case_type: "cma-case",
        }
      }

      let(:es_single_term_query) {
        {
          filter: {
            and: {
              filters: [
                {
                  terms: { case_state: ["open", "closed"] }
                },
                {
                  terms: { case_type: ["cma-case"] }
                }
              ]
            }
          }
        }
      }

      it "creates two term filters" do
        expect(
          query.to_h
            .fetch(:filter)
            .fetch(:and)
            .fetch(:filters)
            .size
        ).to eq(2)
      end

      it "creates a term fitler with multiple values" do
        expect(
          query.to_h
            .fetch(:filter)
            .fetch(:and)
            .fetch(:filters)
            .at(0)
            .fetch(:terms)
            .fetch(:case_state)
            .size
        ).to eq(2)

        expect(
          query.to_h
            .fetch(:filter)
            .fetch(:and)
            .fetch(:filters)
            .at(1)
            .fetch(:terms)
            .fetch(:case_type)
            .size
        ).to eq(1)
      end
    end

    context "when criteria contains date fields" do
      let(:criteria) {
        {
          opened_date: "2005",
          closed_date: ["2005", "2006"]
        }
      }

      let(:es_multiple_range_query) {
        {
          filter: {
            and: {
              filters: [
                {
                  or: {
                    filters: [
                      {
                        range: {
                          opened_date: {
                            from: "2005-01-01",
                            to: "2005-12-31",
                          }
                        }
                      }
                    ]
                  }
                },
                {
                  or: {
                    filters: [
                      {
                        range: {
                          closed_date: {
                            from: "2005-01-01",
                            to: "2005-12-31",
                          }
                        }
                      },
                      {
                        range: {
                          closed_date: {
                            from: "2006-01-01",
                            to: "2006-12-31",
                          }
                        }
                      }
                    ]
                  }
                }
              ]
            }
          }
        }
      }

      it "generates two AND filters" do
        expect(
          query.to_h
            .fetch(:filter)
            .fetch(:and)
            .fetch(:filters)
            .size
        ).to eq(2)
      end

      it "generates a single filter for the single date filter" do
        expect(
          query.to_h
            .fetch(:filter)
            .fetch(:and)
            .fetch(:filters)
            .at(0)
            .fetch(:or)
            .fetch(:filters)
            .size
        ).to eq(1)
      end

      it "generates two or filters for the multiple date filter" do
        expect(
          query.to_h
            .fetch(:filter)
            .fetch(:and)
            .fetch(:filters)
            .at(1)
            .fetch(:or)
            .fetch(:filters)
            .size
        ).to eq(2)
      end

      it "creates a query with multiple ranges" do
        expect(query.to_h).to eq(es_multiple_range_query)
      end
    end

    context "when criteria contains keywords" do
      let(:criteria) {
        {
          "keywords" => "some keywords",
        }
      }

      let(:es_match_query) {
        {
          query: {
            match: {
              _all: "some keywords",
            }
          },
          filter: { and: { filters: [] } }
        }
      }

      it "sends a match query to ElasticSearch" do
        expect(query.to_h).to eq(es_match_query)
      end
    end
  end
end
