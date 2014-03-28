Given(/^there are registered documents$/) do
  responses = put_all_documents

  expect(responses.map(&:status).uniq).to eq([200])

  force_elastic_search_consistency
end

Given(/^there are (\d+) registered documents$/) do |number_of_docs_to_create|
  number_of_docs_to_create.to_i.times.each do |n|
    put_new_document("cma-cases/a-document-#{n}", MultiJson.dump({
      "slug" => "cma-cases/a-document-#{n}",
      "title" => "Title #{n}",
      "summary" => "Summary #{n}",
      "body" => "Body #{n}",
      "opened_date" => "2006-7-14",
      "case_type" => "ca98-and-civil-cartels",
      "case_state" => "open",
      "market_sector" => "distribution-and-service-industries",
    }))
  end

  force_elastic_search_consistency
end

Given(/^there are no registered "(.*?)" documents$/) do |case_type|
  responses = put_all_documents_excluding( "case_type" => case_type )

  expect(responses.map(&:status).uniq).to eq([200])

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

  states = cases.map { |c| c.fetch("case_state").fetch("value") }
  expect(states.all? { |state| state == case_state }).to be_true

  outcomes = cases.map { |c| c.fetch("outcome_type").fetch("value") }
  expect(outcomes.all? { |outcome| outcome == outcome_type }).to be_true
end

Then(/^I receive documents with outcomes "(.*?)" and "(.*?)"$/) do |outcome_one, outcome_two|
  cases = MultiJson.load(@response.body).fetch("results")

  expect(cases).to have(2).items

  outcomes = cases.map { |c| c.fetch("outcome_type").fetch("value") }
  expect(outcomes.all? { |outcome| [outcome_one, outcome_two].include?(outcome) }).to be_true
end

Then(/^I receive documents opened in "(.*?)" and "(.*?)"$/) do |year_one, year_two|
  cases = MultiJson.load(@response.body).fetch("results")

  expect(cases).to have(2).items

  dates = cases.map { |c| c.fetch("opened_date") }
  expect(dates.all? { |d| d.include?(year_one) || d.include?(year_two) }).to be_true
end

Then(/^I receive (\d+) documents$/) do |number_of_docs_to_receive|
  cases = MultiJson.load(@response.body).fetch("results")
  expect(cases).to have(number_of_docs_to_receive.to_i).items
end
