Given(/^there are registered documents$/) do
  # TODO: PUT enpoint
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
