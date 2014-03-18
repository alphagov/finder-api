require 'multi_json'

class ElasticSearchRegisterer
  def initialize(client)
    @http_client = client
  end

  def store_map(mapping)
    @http_client.put(index_path)
    @http_client.put(mapping_path(mapping), json_mapping(mapping))
  end

private

  def index_path
    "/finder-api"
  end

  def mapping_path(mapping)
    "#{index_path}/#{mapping.finder_slug}/_mapping"
  end

  def json_mapping(mapping)
    MultiJson.dump(mapping.to_hash)
  end
end
