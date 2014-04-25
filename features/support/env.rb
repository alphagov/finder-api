$LOAD_PATH.unshift(File.expand_path("../../", File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path("../../lib/", File.dirname(__FILE__)))
require 'byebug'
require 'pry'
require 'awesome_print'

ENV['ELASTIC_SEARCH_BASE_URI'] ||= 'http://localhost:9200'
ENV['ELASTIC_SEARCH_NAMESPACE'] ||= 'finder-api-test'

require 'application'
THE_APPLICATION = Application.new(ENV)

require "rack/test"
require "finder_api"
require "features/support/schema_helpers"
require "features/support/case_helpers"
require "features/support/persistence_helpers"

module SinatraTestIntegration
  include Rack::Test::Methods

  def app
    FinderApi.new
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
