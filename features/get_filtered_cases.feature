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
            "title": "Review of IMS Health undertakings",
            "url": "http://www.competition-commission.org.uk/our-work/directory-of-all-inquiries/review-of-ims-health-incorporated-undertakings",
            "opened_date": "2013-08-06",
            "case_type": {
              "value": "review-of-orders-and-undertakings",
              "label": "Reviews of orders and undertakings"
            },
            "case_state": {
              "value": "open",
              "label": "Open"
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
