class FindDocument
  def initialize(documents, formatter, context)
    @documents = documents
    @formatter = formatter
    @context = context
  end

  def call
    context.success(search_results)
  end

  private

  attr_reader(
    :documents,
    :formatter,
    :context,
  )

  def search_results
    {
      :results => formatted_documents,
    }
  end

  def formatted_documents
    matching_documents.map { |c| formatter.call(c).to_h }
  end

  def matching_documents
    documents.find_by(finder_type, criteria)
  end

  def finder_type
    context.params.fetch("finder_type")
  end

  def criteria
    context.params.except("finder_type")
  end
end

