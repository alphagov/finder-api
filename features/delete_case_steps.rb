When(/^I DELETE "(.*?)"$/) do |path|
  response = delete(path)
  force_elastic_search_consistency

  expect(response.status).to eq(200)
end

Then(/^the document is no longer available$/) do
  response = get("finders/cma-cases/documents.json?case_type=mergers")
  parsed_response = JSON.load(response.body)

  expect(parsed_response.fetch("results")).to be_empty
end
