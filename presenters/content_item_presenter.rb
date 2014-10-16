require "time"

class ContentItemPresenter < Struct.new(:metadata)
  def need_ids
    []
  end

  def public_updated_at
    Time.new.utc.iso8601
  end

  def details
    {}
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
