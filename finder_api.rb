require 'sinatra'
require 'json'

require 'config/logging'
Dir["#{File.dirname(__FILE__)}/config/initializers/*.rb"].each do |path|
  require path
end

require 'application'
THE_APPLICATION ||= Application.new(ENV)
require 'adapters/sinatra_adapter'

class FinderApi < Sinatra::Application

  get '/:slug.json' do |slug|
    schema = app.send(:schemas).fetch(slug)
    sinatra_adapter.success(schema.to_h)
  end

  get '/finders/:finder_type/documents.json' do
    app.find_cases(sinatra_adapter)
  end

  put '/finders/:finder_type/:slug' do
    app.register_case(sinatra_adapter)
  end

  def initialize(*args, &block)
    super

    app.initialize_persistence
  end

  def app
    THE_APPLICATION
  end

  def sinatra_adapter
    SinatraAdapter.new(self)
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
