Feature: Registration with panopticon
  As a developer
  I want to be able to register all finders with panopticon
  So that they appear on the main GOV.UK domain

@stub_panopticon_registerer
Scenario:
  When I run the panopticon:register rake task
  Then the CMA Case finder is registered with panopticon
