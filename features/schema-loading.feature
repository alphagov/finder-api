Feature: Schema loading
  As a product owner
  In order to specify new finders without developer work
  I want schema definitions to be loaded automatically

Scenario: A new schema file has been added
  Given a new schema file has been added
  When the schemas are loaded
  Then the schema is registered with the search backend
