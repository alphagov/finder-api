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
    http_client.post("/#{namespace}/#{finder_type}/_search?size=1000", query)
      .body
      .fetch("hits")
      .fetch("hits")
      .map { |r| r.fetch("_source") }
  end

  def store(slug, document_data)
    http_client.put("/#{namespace}/#{slug}", document_data)
  end

  def delete(slug)
    http_client.delete("/#{namespace}/#{slug}")
  end

  private

  attr_reader :http_client, :query_builder, :namespace
end
