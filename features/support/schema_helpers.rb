module SchemaHelpers
  def load_schema(schema_slug)
    filename = File.expand_path("../../schemas/#{schema_slug}.json", File.dirname(__FILE__))
    MultiJson.load(File.read(filename))
  end
end
