require "forwardable"

class SinatraAdapter
  extend Forwardable
  def initialize(sinatra_app)
    @sinatra_app = sinatra_app
  end

  def params
    sinatra_app.request.params
  end

  def success(content)
    status(200)
    json_body(content)

    return_nil_so_sinatra_does_not_double_render
  end

  def created(content = "")
    status(201)
    json_body(content)

    return_nil_so_sinatra_does_not_double_render
  end

  private

  attr_reader :sinatra_app

  def_delegators :sinatra_app, :status

  def json_body(content)
    sinatra_app.content_type :json

    sinatra_app.body(MultiJson.dump(content))
  end

  def return_nil_so_sinatra_does_not_double_render
    return nil # so sinatra does not double render
  end
end
