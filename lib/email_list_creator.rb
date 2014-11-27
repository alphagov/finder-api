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
            "format" => [metadata["format"]],
          }
        }
      )
    end
  end

private
  attr_reader :metadata, :permutation_generator_class, :api_client_class

  def list_title_for(tag_hash)
    keys = tag_hash[email_signup_choice["key"]]
    keys.collect {|key| name_for_key(key)}.join(" and ")
  end

  def name_for_key(key)
    find_choice_by_key(key)["name"]
  end

  def find_choice_by_key(key)
    email_signup_choice["choices"].select {|choice| choice["key"] == key}[0]
  end

  def permutation_generator
    @generator ||= permutation_generator_class.new(
      metadata["format"],
      email_signup_choice,
    )
  end

  def api_client
    @api_client ||= api_client_class.new(Plek.current.find("email-alert-api"), {timeout: 30})
  end

  def email_signup_choice
    metadata["email_signup_choice"]
  end
end
