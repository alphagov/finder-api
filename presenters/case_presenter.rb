require "core_ext"

class CasePresenter

  def initialize(schema, case_data)
    @schema = schema
    @case_data = case_data
  end

  def to_h
    case_data
      .except(*exclude_fields)
      .merge(expanded_facets)
  end

  private

  attr_reader :schema, :case_data

  def exclude_fields
    %w(
      body
    )
  end

  def expanded_facets
    Hash[expandable_facets.map do |facet_name|
      [ facet_name, expand_facet_value(facet_name) ]
    end]
  end

  def expand_facet_value(facet_name)
    value = case_data.fetch(facet_name)
    {
      "value" => value,
      "label" => schema.label_for(facet_name, value)
    }
  end

  def expandable_facets
    multi_select_field_names & case_data.keys
  end

  def multi_select_field_names
    schema.facets
  end
end
