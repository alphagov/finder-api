class RegisterableSchema
  def initialize(schema)
    @schema = schema
  end

  def slug
    @schema['slug']
  end

  def name
    @schema['name']
  end

  def description
    ""
  end

  def state
    "live"
  end

  def paths
    "/#{slug}"
  end
end