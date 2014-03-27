Given(/^there are registered documents$/) do
  responses = post_all_documents

  expect(responses.map(&:status).uniq).to eq([201])

  force_elastic_search_consistency
end

Given(/^there are no registered "(.*?)" documents$/) do |case_type|
  responses = post_all_documents_excluding( "case_type" => case_type )

  expect(responses.map(&:status).uniq).to eq([201])

  force_elastic_search_consistency
end

When(/^I GET "(.*?)"$/) do |path|
  @response = get(path)
end

Then(/^I receive the following response$/) do |expected_response_body|
  response_data = MultiJson.load(@response.body)
  expected_response_data = MultiJson.load(expected_response_body)

  expect(response_data.fetch("results").first)
    .to eq(expected_response_data.fetch("results").first)
end

Then(/^I receive all documents with an opened date in "(.*?)"$/) do |year|
  cases = MultiJson.load(@response.body).fetch("results")

  expect(cases).to have(1).item

  case_dates = cases.map { |r| r.fetch("opened_date") }
  expect(case_dates.all? { |d| d.include?(year) }).to be_true
end

Then(/^I receive all "(.*?)" documents with outcome "(.*?)"$/) do |case_state, outcome_type|
  cases = MultiJson.load(@response.body).fetch("results")

  expect(cases).to have(1).item
  expect(cases.all? { |c| c.fetch("case_state") == case_state }).to be_true
  expect(cases.all? { |c| c.fetch("outcome_type") == outcome_type }).to be_true
end
