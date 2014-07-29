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
    Array(data.fetch(facet_name)).map { |value|
      {
        "value" => value,
        "label" => schema.label_for(facet_name, value)
      }
    }
  end

  def expandable_facets
    schema.expandable_facet_names & data.keys
  end
end
