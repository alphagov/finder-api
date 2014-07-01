class RegisterSchemasWithElasticSearch
  def initialize(registerer, elastic_search_translator, schemas, context)
    @registerer = registerer
    @elastic_search_translator = elastic_search_translator
    @schemas = schemas
    @context = context
  end

  def call
    create_index
    schemas.each do |schema|
      register_schema(schema)
    end

    context.success(message: "Schemas successfully registered")
  end

  private

  attr_reader(
    :registerer,
    :elastic_search_translator,
    :schemas,
    :context
  )

  def create_index
    registerer.create_index
  end

  def register_schema(schema)
    registerer.store_map(translate_schema_to_mapping(schema))
  end

  def translate_schema_to_mapping(schema)
    elastic_search_translator.call(schema)
  end
end
