When(/^I request the "(.*?)" schema$/) do |slug|
  @response = get("/#{slug}.json")
end

Then(/^I receive a JSON document describing "(.*?)"$/) do |slug|
  expect(@response.status).to eq 200
  parsed_response = MultiJson.load(@response.body)
  expect(parsed_response).to eq load_schema(slug)
end

Given(/^a new schema file has been added$/) do
  @schema_file = create_schema_file(%|{
    "slug": "cma-cases-test",
    "facets": [
      {
        "key": "case_type",
        "allowed_values": [
          {"label": "CA98 and civil cartels", "value": "ca98-and-civil-cartels"}
        ]
      }
    ]
  }|)
end

When(/^the schemas are loaded$/) do
  run_schema_load(@schema_file)
end

Then(/^the schema is registered with the search backend$/) do
  check_for_mapping_in_elasticsearch
end
