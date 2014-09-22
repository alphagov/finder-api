require 'panopticon_registerer'

describe PanopticonRegisterer do
  describe '.register' do
    it "uses GdsApi::Panopticon::Registerer to register the schema" do
      finder_registerer = double("finder_registerer")
      signup_registerer = double("signup_registerer")

      expect(GdsApi::Panopticon::Registerer).to receive(:new)
        .with(owning_app: 'finder-api', rendering_app: 'finder-frontend', kind: 'finder')
        .and_return(finder_registerer)

      expect(GdsApi::Panopticon::Registerer).to receive(:new)
        .with(owning_app: 'finder-api', rendering_app: 'finder-frontend', kind: 'finder_email_signup')
        .and_return(signup_registerer)

      expect(finder_registerer).to receive(:register).twice
      expect(signup_registerer).to receive(:register).twice

      metadata = [
        {slug: "first-finder", name: "first finder"},
        {slug: "second-finder", name: "second finder"},
      ]

      PanopticonRegisterer.new(metadata).call
    end
  end
end
