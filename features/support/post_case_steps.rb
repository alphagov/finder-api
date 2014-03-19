Given(/^there no are registered documents$/) do
  clear_elastic_search
end

When(/^I POST "(.*?)" with the following case data$/) do |path, case_json|
  @response = post(path, case_json)
end

Then(/^I receive an empty (\d+) response$/) do |expected_status|
  expect(@response.status).to eq(expected_status.to_i)
end
