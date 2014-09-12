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

class FinderSignupArtefactPresenter < Struct.new(:metadata)
  def state
    "live"
  end

  def title
    metadata["name"]
  end

  def description
    metadata["signup_copy"]
  end

  def slug
    "#{metadata["slug"]}/email-signup"
  end

  def paths
    ["/#{slug}"]
  end
end
