class RegisterCase
  def initialize(cases_repository, context)
    @cases_repository = cases_repository
    @context = context
  end

  def call
    cases_repository.store(context.params.fetch("case"))

    context.created
  end

  private

  attr_reader :cases_repository, :context
end
