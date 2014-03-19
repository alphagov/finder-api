require "forwardable"

class ElasticSearchRepository
  extend Forwardable

  def initialize(http_client, namespace, finder_type)
    @http_client = http_client
    @namespace = namespace
    @finder_type = finder_type
  end

  def find_by(criteria)
    # TODO: refactor into an adapter
    get("/#{namespace}/_search", criteria)
      .body
      .fetch("hits")
      .fetch("hits")
      .map { |r| r.fetch("_source") }
  end

  def store(case_data)
    post("/#{namespace}/#{finder_type}", case_data)
  end

  private

  attr_reader :http_client, :namespace, :finder_type

  def_delegators :http_client, :get, :post
end
