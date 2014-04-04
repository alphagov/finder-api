require "forwardable"

class ElasticSearchRepository
  extend Forwardable

  def initialize(http_client, query_builder, namespace)
    @http_client = http_client
    @query_builder = query_builder
    @namespace = namespace
  end

  def find_by(finder_type, criteria)
    query = query_builder.call(criteria)

    # TODO: refactor into an adapter
    post("/#{namespace}/#{finder_type}/_search?size=1000", query)
      .body
      .fetch("hits")
      .fetch("hits")
      .map { |r| r.fetch("_source") }
  end

  def store(slug, document_data)
    put("/#{namespace}/#{slug}", document_data)
  end

  private

  attr_reader :http_client, :query_builder, :namespace

  def_delegators :http_client, :post, :put
end
