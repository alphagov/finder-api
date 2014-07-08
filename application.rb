$LOAD_PATH.unshift(File.expand_path("..", __FILE__))
$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require "faraday"
require 'faraday_middleware'

require "core_ext"
require "presenters/document_presenter"
require "elastic_search_repository"
require "elastic_search_registerer"
require "elastic_search_mapping"
require "elastic_search_query"
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

  def find_documents(context)
    FindDocument.new(
      documents_repository,
      document_presenter(context.params.fetch("finder_type")),
      context,
    ).call
  end

  def register_document(context)
    RegisterDocument.new(
      documents_repository,
      context,
    ).call
  end

  def delete_document(context)
    DeleteDocument.new(
      documents_repository,
      context,
    ).call
  end

  def initialize_persistence(context = NullAdapter.new)
    RegisterSchemasWithElasticSearch.new(
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

  def documents_repository
    ElasticSearchRepository.new(
      es_http_client,
      es_query_builder,
      persistence_namespace,
    )
  end

  def es_query_builder
    ->(criteria) {
      ElasticSearchQuery.new(criteria).to_h
    }
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
      conn.request :json
      conn.use Faraday::Response::RaiseError

      conn.adapter Faraday.default_adapter
    end
  end

  def document_presenter(finder_type)
    ->(document_data) {
      DocumentPresenter.new(schema(finder_type), document_data)
    }
  end

  def schema(finder_type)
    schemas.fetch(finder_type)
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
