require "plek"
require "email_list_permutation_generator"
require "gds_api/email_alert_api"

class EmailListCreator
  def initialize(metadata,
                 permutation_generator_class: EmailListPermutationGenerator,
                 api_client_class: GdsApi::EmailAlertApi)
    @metadata = metadata
    @permutation_generator_class = permutation_generator_class
    @api_client_class = api_client_class
  end

  def call
    if metadata["email_signup_choice"]
      tag_hashes = permutation_generator.all_possible_tag_hashes
      tag_hashes.each do |tag_hash|
        api_client.find_or_create_subscriber_list(
          {
            "title" => list_title_for(tag_hash),
            "tags" => tag_hash
          }
        )
      end
    else
      api_client.find_or_create_subscriber_list(
        {
          "title" => metadata["name"],
          "tags" => {
            "format" => [metadata["slug"]],
          }
        }
      )
    end
  end

private
  attr_reader :metadata, :permutation_generator_class, :api_client_class

  def list_title_for(tag_hash)
    key = email_signup_choice["key"]
    key_name = email_signup_choice["key_name"]
    selected_options = tag_hash[key].join(" or ")
    "#{metadata["name"]} with #{key_name} #{selected_options}"
  end

  def permutation_generator
    @generator ||= permutation_generator_class.new(
      metadata["slug"],
      email_signup_choice,
    )
  end

  def api_client
    @api_client ||= api_client_class.new(Plek.current.find("email-alert-api"))
  end

  def email_signup_choice
    metadata["email_signup_choice"]
  end
end
