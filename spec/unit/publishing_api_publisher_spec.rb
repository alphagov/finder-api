require "publishing_api_publisher"

describe PublishingApiPublisher do
  describe '.call' do
    it "uses GdsApi::PublishingApi to publish the Finders" do
      publishing_api = double("publishing-api")

      metadata = [
        {"slug" => "first-finder", "name" => "first finder"},
        {"slug" => "second-finder", "name" => "second finder"},
      ]

      expect(GdsApi::PublishingApi).to receive(:new)
        .with(Plek.new.find("publishing-api"))
        .and_return(publishing_api)

      expect(publishing_api).to receive(:put_content_item).twice

      PublishingApiPublisher.new(metadata).call
    end
  end
end
