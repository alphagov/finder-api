require 'forwardable'

class FinderSchema
  extend Forwardable

  def_delegators :schema, :fetch

  def initialize(schema)
    @schema = schema
  end

  def to_h
    schema
  end

  def expandable_facet_names
    text_facets.map { |facet|
      facet.fetch("key")
    }
  end

  def options_for(facet_name)
    allowed_values_as_option_tuples(allowed_values_for(facet_name))
  end

  def label_for(facet_name, desired_value)
    option_pair = options_for(facet_name)
      .find { |(label, value)|  value == desired_value }

    option_pair && option_pair.first
  end

private
  attr_reader :schema

  def facet_data_for(facet_name)
    schema.fetch("facets", []).find do |facet_record|
      facet_record.fetch("key") == facet_name.to_s
    end || {}
  end

  def allowed_values_for(facet_name)
    facet_data_for(facet_name).fetch("allowed_values", [])
  end

  def allowed_values_as_option_tuples(allowed_values)
    allowed_values.map do |value|
      [
        value.fetch("label", ""),
        value.fetch("value", "")
      ]
    end
  end

  def text_facets
    schema.fetch("facets", []).select { |facet|
      facet.fetch("elasticsearch_config", {}).fetch("type", "text") == "text"
    }
  end
end
