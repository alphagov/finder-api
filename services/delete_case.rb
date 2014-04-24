class DeleteCase
  def initialize(cases_repository, context)
    @cases_repository = cases_repository
    @context = context
  end

  def call
    cases_repository.delete(storage_id)

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
end
