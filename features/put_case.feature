Feature: PUT new cases
  As an case publisher
  I want to be able to register cases with the Finder API
  So that I can search them at a later time

  Scenario: Request all Criminal Cartel CMA cases
    Given there no are registered documents
    When I PUT "/finders/cma-cases/healthcorp-druginc-merger-inquiry" with the following case data
    """
      {
        "slug": "cma-cases/healthcorp-druginc-merger-inquiry",
        "title": "Heathcorp / Druginc merger inquiry",
        "summary": "Inquiry into the Healthcorp / Druginc merger",
        "body": "# Phase 1\n\nThe investigation",
        "opened_date": "2003-12-30",
        "closed_date": "2004-03-01",
        "case_type": "mergers",
        "case_state": "closed",
        "market_sector": "pharmaceuticals",
        "outcome_type": "ca98-infringement-chapter-i",
        "updated_at": "2014-04-15"
      }
    """
    Then I receive an empty 200 response
    And the case eventually shows up in search results
