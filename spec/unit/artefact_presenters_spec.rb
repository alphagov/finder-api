require 'artefact_presenters'

describe 'artefact presenters' do
  let(:signup_copy) { "Lorem ipsum dolor sit amet" }
  let(:metadata) {
    {
      "slug" => "cma-cases",
      "name" => "Competition and Markets Authority cases",
      "signup_copy" => signup_copy,
    }
  }

  context "with a schema artefact presenter" do
    subject(:presenter) { SchemaArtefactPresenter.new(metadata) }

    it "presents a version of a schema appropriate for registration with panopticon" do
      expect(presenter.slug).to eq metadata["slug"]
      expect(presenter.title).to eq metadata["name"]
      expect(presenter.description).to eq ""
      expect(presenter.state).to eq "live"
      expect(presenter.paths).to eq ["/cma-cases", "/cma-cases.json"]
    end
  end

  context "with a finder signup artefact presenter" do
    subject(:presenter) { FinderSignupArtefactPresenter.new(metadata) }

    it "presents a version of a schema appropriate for registration with panopticon" do
      expect(presenter.slug).to eq "cma-cases/email-signup"
      expect(presenter.title).to eq metadata["name"]
      expect(presenter.description).to eq signup_copy
      expect(presenter.state).to eq "live"
      expect(presenter.paths).to eq ["/cma-cases/email-signup"]
    end
  end
end
