require "spec_helper"

require "presenters/document_presenter"

describe DocumentPresenter do
  subject(:presenter) { DocumentPresenter.new(schema, data) }

  let(:data) {
    {
      "title" => title,
      "case_type" => case_type_value,
      "body" => body,
    }
  }

  let(:body) { "## Case Body" }
  let(:title) { "Heathcorp / Druginc merger inquiry" }
  let(:case_type_value) { "criminal-cartels" }
  let(:case_type_label) { "CA98 and civil cartels" }

  let(:schema) {
    double(
      :schema,
      facets: ["case_type"],
    ).tap { |d|
      allow(d).to receive(:label_for)
        .with("case_type", case_type_value)
        .and_return(case_type_label)
    }
  }

  describe "#to_h" do
    it "directly presents normal fields" do
      expect(presenter.to_h).to include( "title" => title )
    end

    it "filters out the body field" do
      expect(presenter.to_h).not_to have_key("body")
    end

    it "expands multi-select fields to include the label and value" do
      expected_case_type_data = {
        "case_type" => [
          "label" => case_type_label,
          "value" => case_type_value,
        ]
      }

      expect(presenter.to_h).to include( expected_case_type_data )
    end

    context "when the case data is missing a multi-select field" do
      let(:data) {
        {
          "title" => title,
        }
      }

      it "presents the available fields" do
        expect(presenter.to_h).to include(data)
      end
    end
  end
end
