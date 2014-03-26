require "forwardable"

class ElasticSearchRepository
  extend Forwardable

  def initialize(http_client, namespace, finder_type)
    @http_client = http_client
    @namespace = namespace
    @finder_type = finder_type
  end

  def find_by(criteria)
    query = criteria_to_es_format(criteria)

    # TODO: refactor into an adapter
    post("/#{namespace}/_search", query)
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

  def criteria_to_es_format(hash)
    criteria = hash.map do |facet, value|
      if facet =~ /_date\Z/
        date_ranges = Array(value).map do |year|
          { range: { facet => {
            from: "#{year}-01-01",
            to: "#{year}-12-31"
          } } }
        end

        { or: { filters: date_ranges } }
      else
        { terms: { facet => Array(value) } }
      end
    end

    query = { filter: { and: { filters: criteria } } }

    MultiJson.dump(query)
  end
end
