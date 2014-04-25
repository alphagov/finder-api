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

  def force_elastic_search_consistency
   system("curl -XPOST 'http://localhost:9200/finder-api-test/_flush'")
  end
end

