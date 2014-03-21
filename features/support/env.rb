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

module SinatraTestIntegration
  include Rack::Test::Methods

  def app
    FinderApi.new
  end
end


module PersistenceHelpers
  extend self

  def elastic_search_base_uri
    ENV['ELASTIC_SEARCH_BASE_URI']
  end

  def elastic_search_namespace
    ENV['ELASTIC_SEARCH_NAMESPACE']
  end

  def clear_elastic_search
    output = `curl -XDELETE '#{elastic_search_base_uri}/#{elastic_search_namespace}' 2>&1`
    raise output unless $?.success?
  end

  def force_elastic_search_consistency
    output = `curl -XPOST '#{elastic_search_base_uri}/#{elastic_search_namespace}/_flush' 2>&1`
    raise output unless $?.success?
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
