module CaseHelpers

  def document_fixture
    {
      "slug" => "cma-cases/healthcorp-druginc-merger-inquiry",
      "title" => "Heathcorp / Druginc merger inquiry",
      "summary" => "Inquiry into the Healthcorp / Druginc merger",
      "body" => "# Phase 1\n\nThe investigation",
      "opened_date" => "2003-12-30",
      "closed_date" => "2004-03-01",
      "case_type" => "mergers",
      "case_state" => "closed",
      "market_sector" => "pharmaceuticals",
      "outcome_type" => "ca98-infringement-chapter-i"
    }
  end

  def document_fixture_json
    MultiJson.dump(document_fixture)
  end

  def post_new_document
    post("/finders/cma-cases", case: document_fixture_json)
  end
end
