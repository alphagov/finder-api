Feature: POST new cases
  As an case publisher
  I want to be able to register cases with the Finder API
  So that I can search them at a later time

  Scenario: Request all Criminal Cartel CMA cases
    Given there no are registered documents
    When I POST "/finders/cma-cases" with the following case data
    """
      {
        "original_url": "http://www.competition-commission.org.uk/our-work/directory-of-all-inquiries/payday-lending",
        "title": "Payday lending market investigation",
        "case_type": "markets",
        "original_urls": [
          "http://www.competition-commission.org.uk/our-work/directory-of-all-inquiries/payday-lending",
        ],
        "date_of_referral": "2013-06-27",
        "statutory_deadline": "2015-06-26",
        "case_state": "open"
      }
    """
    Then I receive an empty 201 response
