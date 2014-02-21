require 'sinatra'
require 'json'

require 'config/logging'
Dir["#{File.dirname(__FILE__)}/config/initializers/*.rb"].each do |path|
  require path
end

class FinderApi < Sinatra::Application

  get '/:slug.json' do |slug|
    MultiJson.dump(SchemaRegistry.new.get(slug))
  end

  get '/finders/:slug/documents.json' do
    matched_cases = params['case_type'] ? cases_for_case_type(params['case_type']) : cases

    content_type :json
    json_for_cases(matched_cases)
  end

  def json_for_cases(cases)
    {
      document_noun: 'case',
      documents: cases
    }.to_json
  end

  def cases_for_case_type(case_type)
    cases.select do |case_hash|
      case_type_metadata = case_hash['metadata'].find do |meta|
        meta['name'] == 'case_type'
      end

      case_type_metadata['value'] == case_type
    end
  end

  def cases
    @cases ||= case_files.map do |filename|
      JSON.load(File.new(filename))
    end
  end

  def case_files
    Dir.foreach('cases').select { |x| x =~ /\.json\Z/ }.map do |filename|
      "cases/#{filename}"
    end
  end
end
