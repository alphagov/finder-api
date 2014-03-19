Feature: GET filtered cases
  As an API client
  I want to be able to get case data filtered by type
  So that I can present them to my users

  Scenario: Request all Criminal Cartel CMA cases
    Given there are registered documents
    When I GET "/finders/cma-cases/documents.json?case_type=review-of-orders-and-undertakings"
    Then I receive the following response
    """
      {
        "results": [
          {
            "title": "Heathcorp / Druginc merger inquiry",
            "slug": "cma-cases/healthcorp-druginc-merger-inquiry",
            "opened_date": "2003-12-30",
            "closed_date": "2004-03-01",
            "summary": "Inquiry into the Healthcorp / Druginc merger",

            "market_sector": {
              "value": "pharmaceuticals",
              "label": "Pharmaceuticals"
            },
            "case_type": {
              "value": "mergers",
              "label": "Mergers"
            },
            "outcome_type": {
              "value": "ca98-infringement-chapter-i",
              "label": "CA98 - infringement Chapter I"
            },
            "case_state": {
              "value": "closed",
              "label": "Closed"
            }
          }
        ]
      }
    """

  Scenario: filter by opened date
  Scenario: filter by closed date
  Scenario: filter by case state
  Scenario: filter by market sector
  Scenario: filter by outcome type
