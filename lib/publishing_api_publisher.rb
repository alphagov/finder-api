require "gds_api/publishing_api"
require "presenters/content_item_presenter"
require "presenters/finder_content_item_presenter"
require "presenters/finder_signup_content_item_presenter"

class PublishingApiPublisher
  def initialize(schemae)
    @schemae = schemae
  end

  def call
    schemae.each do |metadata|
      export_finder(metadata)
      export_signup(metadata) if metadata.has_key?("signup_content_id")
    end
  end

private
  attr_reader :schemae

  def export_finder(metadata)
    attrs = exportable_attributes(FinderContentItemPresenter.new(metadata))
    if metadata.has_key?("signup_content_id")
      attrs["links"].merge!( { "finder_email_signup" => [metadata["signup_content_id"]] })
    end
    publishing_api.put_content_item(attrs["base_path"], attrs)
  end

  def export_signup(metadata)
    attrs = exportable_attributes(FinderSignupContentItemPresenter.new(metadata))
    publishing_api.put_content_item(attrs["base_path"], attrs)
  end

  def publishing_api
    @publishing_api ||= GdsApi::PublishingApi.new(Plek.new.find("publishing-api"))
  end

  def exportable_attributes(item)
    {
      "base_path" => item.base_path,
      "format" => item.format,
      "content_id" => item.content_id,
      "title" => item.title,
      "description" => item.description,
      "public_updated_at" => item.public_updated_at,
      "update_type" => "major",
      "publishing_app" => "finder-api",
      "rendering_app" => item.rendering_app,
      "routes" => item.routes,
      "details" => {},
      "links" => {
        "organisations" => item.organisations,
        "topics" => [],
        "related" => item.related,
      },
    }
  end
end
