class RegisterCase
  def initialize(cases_repository, context)
    @cases_repository = cases_repository
    @context = context
  end

  def call
    logger = Logger.new("log/production.log")
    logger.info("storage_id: #{storage_id}")
    logger.info("document_data: #{document_data.inspect}")

    response = cases_repository.store(storage_id, document_data)
    logger.info("response: #{response.inspect}")

    context.success
  end

  private

  attr_reader :cases_repository, :context

  def storage_id
    [finder_type, document_slug].join("/")
  end

  def document_slug
    context.params.fetch("slug")
  end

  def finder_type
    context.params.fetch("finder_type")
  end

  def document_data
    context.params.fetch("document")
  end
end
