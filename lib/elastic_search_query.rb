class ElasticSearchQuery
  def initialize(criteria)
    @date_criteria = {}
    @term_criteria = {}

    segregate_criteria(criteria)
  end

  def to_h
    match_query.merge(filter_query)
  end

  private

  attr_reader :keywords, :date_criteria, :term_criteria

  def segregate_criteria(criteria)
    @keywords = criteria.fetch("keywords", "")

    criteria
      .except("keywords")
      .each do |k, v|
        if k.to_s.end_with?("_date")
          @date_criteria.merge!( k => v )
        else
          @term_criteria.merge!( k => v )
        end
      end
  end

  def match_query
    if keywords.empty?
      {}
    else
      {
        query: {
          match: {
            _all: keywords,
          }
        }
      }
    end
  end

  def filter_query
    { filter: { and: { filters: filters } } }
  end

  def filters
    if date_filters.empty?
      term_filters
    else
      term_filters + date_filters
    end
  end

  def term_filters
    term_criteria
      .map { |facet, value|
        { terms: { facet => Array(value) } }
      }
  end

  def date_filters
    date_criteria.map { |field_name, values|
      single_date_field_filter(field_name, values)
    }
  end

  def single_date_field_filter(field_name, years)
    {
      or: {
        filters: Array(years).map { |year| date_range_filter(field_name, year) }
      }
    }
  end

  def date_range_filter(field_name, year)
    {
      range: {
        field_name => {
          from: "#{year}-01-01",
          to: "#{year}-12-31",
        }
      }
    }
  end
end
