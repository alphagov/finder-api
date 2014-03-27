$LOAD_PATH.unshift(File.expand_path("..", __FILE__))
$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require "faraday"
require 'faraday_middleware'

require "core_ext"
require "presenters/case_presenter"
require "elastic_search_repository"
require "elastic_search_registerer"
require "elastic_search_mapping"
require "finder_schema"
require "schema_registry"
require "adapters/null_adapter"

Dir.glob("services/*.rb").each { |f| require f }

class Application
  def initialize(env, schemas_glob: default_schemas_glob)
    @elastic_search_base_uri = env.fetch("ELASTIC_SEARCH_BASE_URI")
    @persistence_namespace = env.fetch("ELASTIC_SEARCH_NAMESPACE")
    @schemas_glob = schemas_glob
  end

  def find_case(context)
    FindCase.new(
      cases_repository,
      case_presenter,
      context,
    ).call
  end

  def register_case(context)
    RegisterCase.new(
      cases_repository,
      context,
    ).call
  end

  def initialize_persistence(context = NullAdapter.new)
    RegisterSchemaWithElasticSearch.new(
      schema_registerer,
      elastic_search_translator,
      schemas.values,
      context,
    ).call
  end

  private

  attr_reader(
    :elastic_search_base_uri,
    :persistence_namespace,
    :schemas_glob,
  )

  def cases_repository
    ElasticSearchRepository.new(es_http_client, persistence_namespace)
  end

  def elastic_search_translator
    ElasticSearchMapping.method(:new)
  end

  def schema_registerer
    ElasticSearchRegisterer.new(es_http_client, persistence_namespace)
  end

  def es_http_client
    Faraday.new(:url => @elastic_search_base_uri) do |conn|
      conn.response :json

      conn.adapter Faraday.default_adapter
    end
  end

  def case_presenter
    ->(case_data) {
      CasePresenter.new(cma_schema, case_data)
    }
  end

  def cma_schema
    schemas.fetch(finder_type)
  end

  def finder_type
    "cma-cases"
  end

  def schemas
    Hash[
      SchemaRegistry.new(schemas_glob).all.map { |slug, schema|
        [slug, FinderSchema.new(schema)]
      }
    ]
  end

  def default_schemas_glob
    "schemas/**/*.json"
  end
end
