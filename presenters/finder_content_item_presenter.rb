class FinderContentItemPresenter < ContentItemPresenter
  def title
    metadata["name"]
  end

  def content_id
    metadata["content_id"]
  end

  def base_path
    "/#{metadata["slug"]}"
  end

  def description
    ""
  end

  def details
    {
      beta: metadata.fetch("beta", false),
      document_noun: schema["document_noun"],
      document_type: metadata["format"],
      facets: schema["facets"],
    }
  end

  def format
    "finder"
  end

  def related
    metadata.fetch("related", [])
  end

  def routes
    [
      {
        path: base_path,
        type: "exact",
      },
      {
        path: "#{base_path}.json",
        type: "exact",
      }
    ]
  end
end
