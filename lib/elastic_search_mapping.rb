require 'delegate'

class ElasticSearchMapping
  def initialize(schema)
    @schema = schema
  end

  def to_h
    mapping
  end

  def finder_slug
    @schema.fetch('slug')
  end

private

  def mapping
    {
      finder_slug => {
        "properties" => properties
      }
    }
  end

  def properties
    default_properties.merge(facet_properties)
  end

  def facet_properties
    facets.reduce({}) do |hash, facet|
      hash.merge(facet.fetch("key") => {
        'type' => 'string',
        'index' => 'not_analyzed'
      })
    end
  end

  def facets
    @schema.fetch("facets")
  end

  def default_properties
    {
      "updated_at" => {
        "type" => "date",
        "index" => "not_analyzed",
      },
      "title" => {
        "type" => "string",
        "index" => "analyzed",
      },
      "body" => {
        "type" => "string",
        "index" => "analyzed",
      },
      "summary" => {
        "type" => "string",
        "index" => "analyzed",
      },
    }
  end
end
