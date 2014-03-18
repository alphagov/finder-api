require 'delegate'

class ElasticSearchMapping
  def initialize(schema)
    @schema = schema
  end

  def to_hash
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
end
