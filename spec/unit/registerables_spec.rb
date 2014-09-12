require 'registerables'

describe Registerables::Schema do
  let(:metadata) {
    {
      "slug" => "cma-cases",
      "name" => "Competition and Markets Authority cases",
    }
  }

  let(:registerable) { Registerables::Schema.new(metadata) }

  it "presents a version of a schema appropriate for registration with panopticon" do
    expect(registerable.slug).to eq metadata["slug"]
    expect(registerable.title).to eq metadata["name"]
    expect(registerable.description).to eq ""
    expect(registerable.state).to eq "live"
    expect(registerable.paths).to eq ["/cma-cases", "/cma-cases.json"]
  end
end
