require 'sinatra'
require 'json'

require 'config/logging'
Dir["#{File.dirname(__FILE__)}/config/initializers/*.rb"].each do |path|
  require path
end

require 'application'

require 'schema_registry'

class FinderApi < Sinatra::Application

  get '/:slug.json' do |slug|
    schema = app.send(:schema_registry).fetch(slug)
    success(schema)
  end

  get '/finders/:slug/documents.json' do
    app.find_case(
      sinatra_adapter,
    )
  end

  post '/finders/:slug' do
    status(201)
  end

  def app
    Application.new
  end

  def sinatra_adapter
    self
  end

  # TODO: extract these into another object
  module SinatraAdapter
    def success(content)
      status(200)
      json_body(content)

      return_nil_so_sinatra_does_not_double_render
    end

    def json_body(content)
      content_type :json

      body(MultiJson.dump(content))
    end
  end

  include SinatraAdapter

  def return_nil_so_sinatra_does_not_double_render
    return nil # so sinatra does not double render
  end

  def json_for_cases(cases)
    {
      document_noun: 'case',
      documents: cases
    }.to_json
  end

end

# This prevents the all too common issue of a request for JSON sending back a
# HTML web page with the error info on.
# TODO: Send PR to fix this in Sinatra and remove
Sinatra::ShowExceptions.class_eval do
  def prefers_plain_text?(env)
    !client_accepts_html?(env)
  end

  private

  def client_accepts_html?(env)
    env['HTTP_ACCEPT'].to_s.include?('text/html')
  end
end

