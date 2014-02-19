Feature: Schemas
  As a client of the finder API
  In order to correctly present the user interface for a finder
  I want to be able to get the schema of the finder

Scenario:
  When I request the "cma-cases" schema
  Then I receive a JSON document describing "cma-cases"
