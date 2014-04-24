Feature: DELETE case
  As an API client
  I want to be able to delete cases from the finder
  So that it is no longer publicly accessible

  Scenario: Delete existing case
    Given there are registered documents
    When I DELETE "/finders/cma-cases/healthcorp-druginc-merger-inquiry"
    Then the document is no longer available
