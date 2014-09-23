When(/^I request the "(.*?)" schema$/) do |slug|
  @response = get("/finders/#{slug}/schema.json")
end

Then(/^I receive a JSON document describing "(.*?)"$/) do |slug|
  expect(@response.status).to eq 200
  parsed_response = MultiJson.load(@response.body)
  expect(parsed_response).to eq load_schema(slug)
end
