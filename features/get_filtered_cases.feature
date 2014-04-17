Feature: GET filtered cases
  As an API client
  I want to be able to get case data filtered by type
  So that I can present them to my users

  Scenario: Request all CMA "Mergers" cases
    Given there are registered documents
    When I GET "/finders/cma-cases/documents.json?case_type=mergers"
    Then I receive the following response
    """
      {
        "results": [
          {
            "title": "Heathcorp / Druginc merger inquiry",
            "slug": "cma-cases/healthcorp-druginc-merger-inquiry",
            "opened_date": "2005-12-30",
            "closed_date": "2006-03-01",
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
              "value": "mergers-phase-1-found-not-to-qualify",
              "label": "Mergers - phase 1 found not to qualify"
            },
            "case_state": {
              "value": "closed",
              "label": "Closed"
            }
          }
        ]
      }
    """

  Scenario: No Mergers documents available
   Given there are no registered "mergers" documents
    When I GET "/finders/cma-cases/documents.json?case_type=mergers"
    Then I receive the following response
    """
      {
       "results": []
      }
    """

  Scenario: Filter by opened date
    Given there are registered documents
    When I GET "/finders/cma-cases/documents.json?opened_date=2006"
    Then I receive all documents with an opened date in "2006"

  Scenario: Filter by single values over multiple fields
    Given there are registered documents
    When I GET "/finders/cma-cases/documents.json?outcome_type=ca98-infringement-chapter-i&case_state=closed"
    Then I receive all "closed" documents with outcome "ca98-infringement-chapter-i"

  Scenario: Filter by multiple values for a single field
    Given there are registered documents
    When I GET "/finders/cma-cases/documents.json?outcome_type[]=ca98-infringement-chapter-i&outcome_type[]=mergers-phase-1-found-not-to-qualify"
    Then I receive documents with outcomes "ca98-infringement-chapter-i" and "mergers-phase-1-found-not-to-qualify"

  Scenario: Filter by multiple values for a single date field
    Given there are registered documents
    When I GET "/finders/cma-cases/documents.json?opened_date[]=2003&opened_date[]=2006"
    Then I receive documents opened in "2003" and "2006"

  Scenario: More than 10 documents are in the system
    Given there are 11 registered documents
    When I GET "/finders/cma-cases/documents.json"
    Then I receive 11 documents

  Scenario: Keyword search for exact match
    Given there are registered documents
    When I GET "/finders/cma-cases/documents.json?keywords=fuels"
    Then I receive all documents with a body or summary containing the keywords

  Scenario: Keyword search with stemming
    Given there are registered documents
    When I GET "/finders/cma-cases/documents.json?keywords=fuel"
    Then I receive all documents with a body or summary containing the keywords
