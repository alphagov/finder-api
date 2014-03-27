Given(/^there no are registered documents$/) do
  clear_elastic_search
end

When(/^I PUT "(.*?)" with the following case data$/) do |path, case_json|
  @new_case_data = MultiJson.load(case_json)
  @response = put(path, { document: case_json })

  force_elastic_search_consistency
end

Then(/^I receive an empty (\d+) response$/) do |expected_status|
  expect(@response.status).to eq(expected_status.to_i)
end

Then(/^the case eventually shows up in search results$/) do
  # TODO: search by title?
  @response = get("/finders/cma-cases/documents.json?case_type=mergers")
  expect(@response.status).to eq(200)

  parsed_body = MultiJson.load(@response.body)
  returned_case = parsed_body.fetch("results").first

  expect(returned_case.fetch("title")).to eq(@new_case_data.fetch("title"))
end
