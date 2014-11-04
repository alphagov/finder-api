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

  def format
    "finder"
  end

  def related
    metadata.fetch("related", [])
  end

  def details
    {}
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
