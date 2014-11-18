namespace :publishing_api do
  desc "Publish all Finders to the Publishing API"
  task :publish do
    require "application"
    require "publishing_api_publisher"

    require "multi_json"

    metadata = Dir.glob("metadata/**/*.json").map do |file_path|
      MultiJson.load(File.read(file_path))
    end

    schemae = Dir.glob("schemas/**/*.json").map do |file_path|
      MultiJson.load(File.read(file_path))
    end

    PublishingApiPublisher.new(metadata, schemae).call
  end
end
