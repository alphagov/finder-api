require 'panopticon_registerer'

describe PanopticonRegisterer do
  describe '.register' do
    it "uses GdsApi::Panopticon::Registerer to register the schema" do

      mock_registerer = double("registerer")

      first_registerable = double("first_registerable")
      second_registerable = double("second_registerable")
      mock_registerables = [first_registerable, second_registerable]

      expect(GdsApi::Panopticon::Registerer).to receive(:new)
        .with(owning_app: 'finder-api', rendering_app: 'finder-frontend', kind: 'finder')
        .and_return(mock_registerer)

      expect(mock_registerer).to receive(:register).with(first_registerable)
      expect(mock_registerer).to receive(:register).with(second_registerable)

      PanopticonRegisterer.register(mock_registerables)
    end
  end
end
