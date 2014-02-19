When(/^I request the "(.*?)" schema$/) do |slug|
  @response = get("/#{slug}.json")
end

Then(/^I receive a JSON document describing "(.*?)"$/) do |slug|
  filename = File.expand_path("../../schemas/#{slug}.json", File.dirname(__FILE__))
  expect(@response.status).to eq 200
  expect(@response.body).to eq File.read(filename)
end
