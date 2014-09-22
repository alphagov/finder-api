class SchemaArtefactPresenter < Struct.new(:metadata)
  def state
    "live"
  end

  def title
    metadata["name"]
  end

  def description
    ""
  end

  def slug
    metadata["slug"]
  end

  def paths
    ["/#{slug}", "/#{slug}.json"]
  end
end


