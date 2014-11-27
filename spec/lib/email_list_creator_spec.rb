require "spec_helper"
require "email_list_creator"
require "multi_json"

describe EmailListCreator do
  let(:permutation_generator_class) { double(:permutation_generator_class, new: permutation_generator) }
  let(:permutation_generator) { double(:permutation_generator, all_possible_tag_hashes: []) }

  let(:email_alert_api_class) { double(:email_alert_api_class, new: email_alert_api_client) }
  let(:email_alert_api_client) { double(:email_alert_api_client) }

  subject(:list_creator) {
    EmailListCreator.new(metadata,
      permutation_generator_class: permutation_generator_class,
      api_client_class: email_alert_api_class,
    )
  }

  context "with signup choices" do
    let(:metadata) { JSON.parse(File.read('spec/fixtures/sample_metadata_with_signup_choices.json')) }

    it "requests the possible permutations" do
      expect(permutation_generator_class).to receive(:new).with(
        metadata["format"],
        metadata["email_signup_choice"],
      )
      expect(permutation_generator).to receive(:all_possible_tag_hashes)

      list_creator.call
    end

    it "calls the email-alert-api once for each permutation" do
      allow(permutation_generator).to receive(:all_possible_tag_hashes).and_return(
        [
          {"format" => ["finder_format"], "zone" => ["industrial"]},
          {"format" => ["finder_format"], "zone" => ["commercial"]},
          {"format" => ["finder_format"], "zone" => ["industrial", "commercial"]},
        ]
      )

      {
        "Industrial zones" => ["industrial"],
        "Commercial zones" => ["commercial"],
        "Industrial zones and Commercial zones" => ["industrial", "commercial"],
      }.each_pair do |title, zones|
        expect(email_alert_api_client).to receive(:find_or_create_subscriber_list).with(
          {
            "title" => title,
            "tags" => {
              "format" => ["finder_format"],
              "zone" => zones,
            }
          }
        )
      end

      list_creator.call
    end
  end

  context "without signup choices" do
    let(:metadata) { JSON.parse(File.read('spec/fixtures/sample_metadata.json')) }
    it "calls the email-alert-api once" do
      expect(email_alert_api_client).to receive(:find_or_create_subscriber_list).with(
        {
          "title" => "Test Format reports",
          "tags" => {
            "format" => ["finder_format"]
          }
        }
      )

      list_creator.call
    end
  end
end
