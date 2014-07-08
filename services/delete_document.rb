class DeleteDocument
  def initialize(repository, context)
    @repository = repository
    @context = context
  end

  def call
    repository.delete(storage_id)

    context.success
  end

  private

  attr_reader :repository, :context

  def storage_id
    [finder_type, document_slug].join("/")
  end

  def document_slug
    context.params.fetch("slug")
  end

  def finder_type
    context.params.fetch("finder_type")
  end
end
