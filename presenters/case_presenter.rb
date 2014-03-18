class CasePresenter

  def initialize(schema, case_data)
    @schema = schema
    @case_data = case_data.stringify_keys
  end

  def to_h
    case_data
      .slice(*direct_copy_fields)
      .merge(other_fields)
  end

  private

  attr_reader :schema, :case_data

  def direct_copy_fields
    %w(
      title
    )
  end

  def other_fields
    {
      "opened_date" => opened_date,
      "url" => url,
      "case_type" => schema_label_and_value_pair_for("case_type"),
      "case_state" => schema_label_and_value_pair_for("case_state"),
    }
  end

  def opened_date
    case_data.fetch("date_of_referral")
  end

  def url
    case_data.fetch("original_urls").first
  end

  def schema_label_and_value_pair_for(field_name)
    value = fetch_value_for(field_name)

    {
      "value" => value,
      "label" => schema_label_for(field_name, value)
    }
  end

  def fetch_value_for(field_name)
    case_data.fetch(field_name)
  end

  def schema_label_for(field_name, value)
    schema
      .fetch("facets")
      .find { |hash| hash.fetch("key") == field_name }
      .fetch("allowed_values")
      .find { |hash| hash.fetch("value") == value }
      .fetch("label")
  end
end
