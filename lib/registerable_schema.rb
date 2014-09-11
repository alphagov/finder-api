class RegisterableSchema
  def initialize(schema)
    @schema = schema
  end

  def slug
    @schema['slug']
  end

  def title
    @schema['name']
  end

  def description
    ""
  end

  def state
    "live"
  end

  def paths
    ["/#{slug}", "/#{slug}.json", "/#{slug}/signup"]
  end
end
