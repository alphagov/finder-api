require 'registerable_schema'

describe RegisterableSchema do
  let(:schema) {
    {
      "slug" => "cma-cases",
      "name" => "Competition and Markets Authority cases"
    }
  }

  let(:registerable) { RegisterableSchema.new(schema) }

  it "presents a version of a schema appropriate for registration with panopticon" do
    expect(registerable.slug).to eq schema['slug']
    expect(registerable.name).to eq schema['name']
    expect(registerable.description).to eq ""
    expect(registerable.state).to eq "live"
    expect(registerable.paths).to eq "/cma-cases"
  end
end
