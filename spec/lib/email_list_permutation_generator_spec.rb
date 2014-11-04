require "email_list_permutation_generator"
require "spec_helper"

describe EmailListPermutationGenerator do
  let(:metadata) { JSON.parse(File.read('spec/fixtures/sample_metadata_with_signup_choices.json')) }
  let(:choices_hash) { metadata["email_signup_choice"] }
  let(:finder_slug) { metadata["slug"] }

  subject(:creator) {
    EmailListPermutationGenerator.new(
      finder_slug,
      choices_hash,
    )
  }

  describe "#each_combination_of" do
    it "correctly identifies array combinations" do
      expect(creator.send(:each_combination_of, choices_hash["choices"])).to eq([
        ["industrial"],
        ["commercial"],
        ["industrial", "commercial"],
      ])
    end
  end

  describe "#all_possible_tag_hashes" do
    let(:required_tags) {
      [
        {"format" => [finder_slug], "zone" => ["industrial"]},
        {"format" => [finder_slug], "zone" => ["commercial"]},
        {"format" => [finder_slug], "zone" => ["industrial", "commercial"]},
      ]
    }

    it "returns the correct tag hashes" do
      expect(creator.all_possible_tag_hashes).to eq(required_tags)
    end
  end
end
