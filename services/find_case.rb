class FindCase
  def initialize(cases, case_formatter, context)
    @cases = cases
    @case_formatter = case_formatter
    @context = context
  end

  def call
    context.success(search_results)
    nil
  end

  private

  attr_reader(
    :cases,
    :case_formatter,
    :context,
  )

  def search_results
    {
      :results => formatted_cases,
    }
  end

  def formatted_cases
    matching_cases.map { |c| case_formatter.call(c).to_h }
  end

  def matching_cases
    cases.find_by(criteria)
  end

  def criteria
    context.params
  end
end

