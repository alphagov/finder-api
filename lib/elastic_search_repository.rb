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
    post("/#{namespace}/_search", criteria_to_es_format(criteria))
      .body
      .tap { |o| binding.pry}
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

  def criteria_to_es_format(hash)
    if hash.has_key?("opened_date")
      range_query = {
        "query" => {
          "range" => {
            "opened_date" => {
              "from" => hash.fetch("opened_date"),
              "to" => hash.fetch("opened_date"),
            }
          }
        }
      }

      MultiJson.dump(range_query)
    else
      query = {
        query: {
          bool: {
            must: hash.map { |k, v| { term: { k => [*v].join } } }
          }
        }
      }

      MultiJson.dump(query)
    end
  end
end
