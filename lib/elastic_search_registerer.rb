require 'multi_json'

class ElasticSearchRegisterer
  def initialize(client, namespace)
    @http_client = client
    @namespace = namespace
  end

  def store_map(mapping)
    http_client.put(index_path)
    http_client.put(mapping_path(mapping), json_mapping(mapping))
  end

private
  attr_reader :http_client, :namespace

  def index_path
    "/#{namespace}"
  end

  def mapping_path(mapping)
    [index_path, mapping.finder_slug, "_mapping"].join("/")
  end

  def json_mapping(mapping)
    MultiJson.dump(mapping.to_h)
  end
end
