require 'spec_helper'

require 'finder_schema'

describe FinderSchema do
  subject(:finder_schema) {
    FinderSchema.new(schema_hash)
  }

  let(:schema_hash) {
    {
      "slug" => "cma-cases",
      "name" => "Competition and Markets Authority cases",
      "document_noun" => "case",
      "facets" => [
        {
          "key" => "case_type",
          "name" => "Case type",
          "type" => "single-select",
          "include_blank" => "All case types",
          "allowed_values" => [
            {"label" => "CA98 and civil cartels", "value" => "ca98-and-civil-cartels"}
          ]
        },
        {
          "key" => "opened_date",
          "name" => "Opened date",
          "type" => "multi-select",
          "elasticsearch_config" => {
            "type" => "date",
          },
          "allowed_values" => [
            {"label" => "2011", "value" => "2011"},
            {"label" => "2010", "value" => "2010"},
            {"label" => "2009", "value" => "2009"},
            {"label" => "2008", "value" => "2008"},
          ],
        },
      ]
    }
  }

  describe "#fetch" do
    it "fetches from the hash" do
      expect(finder_schema.fetch("document_noun"))
        .to eq(schema_hash.fetch("document_noun"))
    end
  end

  describe "#expandable_facet_names" do
    it "returns a list of facet names that can be expanded using the schema" do
      expect(finder_schema.expandable_facet_names).to eq(["case_type"])
    end
  end

  describe "#options_for" do
    it "returns the options for a given facet" do
      expect(
        finder_schema.options_for("case_type")
      ).to eq([["CA98 and civil cartels", "ca98-and-civil-cartels"]])
    end
  end

  describe "#label_for" do
    it "returns the label for a particular facet value" do
      expect(
        finder_schema.label_for("case_type", "ca98-and-civil-cartels")
      ).to eq("CA98 and civil cartels")
    end

    context "when the facet value is not an allowed value" do
      it "returns nil" do
        expect(
          finder_schema.label_for("case_type", "not-allowed")
        ).to be_nil
      end
    end
  end
end
