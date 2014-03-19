$LOAD_PATH.unshift(File.expand_path("../../", File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path("../../lib/", File.dirname(__FILE__)))

require "rack/test"
require "finder_api"
require "features/support/schema_helpers"
require 'byebug'

module SinatraTestIntegration
  include Rack::Test::Methods

  def app
    FinderApi.new
  end
end

module PersistenceHelpers
  extend self

  def clear_elastic_search
    delete_command = "curl -XDELETE 'http://localhost:9200/finder-api-test'"
    system(delete_command)
  end
end

World(SinatraTestIntegration)
World(SchemaHelpers)
World(PersistenceHelpers)

Around do |_, block|
  PersistenceHelpers.clear_elastic_search
  block.call
  PersistenceHelpers.clear_elastic_search
end
