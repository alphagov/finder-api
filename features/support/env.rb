$LOAD_PATH.unshift(File.expand_path("../../", File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path("../../lib/", File.dirname(__FILE__)))
require 'byebug'
require 'pry'
require 'awesome_print'

require "rack/test"
require "finder_api"
require "features/support/schema_helpers"
require "features/support/case_helpers"

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

  def force_elastic_search_consistency
   system("curl -XPOST 'http://localhost:9200/finder-api-test/_flush'")
  end
end

World(SinatraTestIntegration)
World(SchemaHelpers)
World(CaseHelpers)
World(PersistenceHelpers)

Around do |_, block|
  PersistenceHelpers.clear_elastic_search
  block.call
  PersistenceHelpers.clear_elastic_search
end
