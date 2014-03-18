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
    cases_for_case_type(context.params.fetch("case_type"))
  end

  def cases_for_case_type(case_type)
    cases.select { |case_hash|
      case_hash.fetch("case_type") == case_type
    }
  end
end

