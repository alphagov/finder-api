require "core_ext"

class DocumentPresenter

  def initialize(schema, data)
    @schema = schema
    @data = data
  end

  def to_h
    data
      .except(*exclude_fields)
      .merge(expanded_facets)
  end

  private

  attr_reader :schema, :data

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
    value = data.fetch(facet_name)
    {
      "value" => value,
      "label" => schema.label_for(facet_name, value)
    }
  end

  def expandable_facets
    multi_select_field_names & data.keys
  end

  def multi_select_field_names
    schema.facets
  end
end
