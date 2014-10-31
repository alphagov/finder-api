namespace :email_subscriptions do
  desc "Ensure there is a topic for every combination of email subscription on govdelivery"
  task :register_subscriptions do
    require "application"
    require "email_list_creator"
    require "multi_json"

    Dir.glob("metadata/**/*.json").each do |file_path|
      metadata = MultiJson.load(File.read(file_path))
      EmailListCreator.new(metadata).call
    end
  end
end
