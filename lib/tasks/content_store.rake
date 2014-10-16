namespace :content_store do
  desc "Publish all Finders to the Content Store"
  task :publish do
    require "application"
    require "publishing_api_publisher"

    require "multi_json"

    metadata = Dir.glob("metadata/**/*.json").map do |file_path|
      MultiJson.load(File.read(file_path))
    end

    PublishingApiPublisher.new(metadata).call
  end
end
