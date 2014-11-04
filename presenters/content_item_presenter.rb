require "time"

class ContentItemPresenter < Struct.new(:metadata)
  def need_ids
    []
  end

  def public_updated_at
    Time.new.utc.iso8601
  end

  # Put this into the details hash in the content store to let finder-frontendd render the checkboxes.
  def details
    {
      tag_key: "alert_type",
      tags: ["devices", "drugs"],
    }
  end

  def rendering_app
    "finder-frontend"
  end

  def organisations
    metadata["organisations"]
  end

  def update_type
    "minor"
  end
end
