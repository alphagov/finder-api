require "services/find_case"
require "lib/core_ext"
require "presenters/case_presenter"

class Application
  def find_case(context)
    FindCase.new(
      cases_repository,
      case_presenter,
      context,
    ).call
  end

  private

  def cases_repository
    @cases ||= Dir.glob('features/support/fixtures/cases/**/*.json').map { |f|
      JSON.load(File.read(f))
    }
  end

  def case_presenter
    ->(case_data) {
      CasePresenter.new(cma_schema, case_data)
    }
  end

  def cma_schema
    schema_registry.fetch("cma-cases")
  end

  def schema_registry
    SchemaRegistry.new(schema_path)
  end

  def schema_path
    "schemas"
  end
end
