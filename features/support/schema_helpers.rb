require 'open-uri'

module SchemaHelpers
  def load_schema(schema_slug)
    filename = File.expand_path("../../schemas/#{schema_slug}.json", File.dirname(__FILE__))
    MultiJson.load(File.read(filename))
  end

  def create_schema_file(schema_json)
    tempfile = Tempfile.new('finder-schema')
    tempfile.puts schema_json
    tempfile.close
    tempfile
  end

  def run_schema_load(schema_file)
    system("./bin/load_schemas #{schema_file.path}")
    schema_file.unlink
  end

  def check_for_mapping_in_elasticsearch
    mapping_json = open(ELASTIC_SEARCH_BASE_URI + "/finder-api-test/cma-cases/_mapping")
    response = MultiJson.load(mapping_json)

    mapping = response.fetch("cma-cases").fetch("properties")

    expect(mapping).to have_key('case_type')
  end
end
