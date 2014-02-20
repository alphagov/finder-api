require 'panopticon_registerer'

describe PanopticonRegisterer do
  describe '.register' do
    it "uses GdsApi::Panopticon::Registerer to register the schema" do
      mock_schema = double("schema")
      mock_registerer = double("registerer")
      mock_registerable_schema = double("registerable schema")
      expect(GdsApi::Panopticon::Registerer).to receive(:new)
        .with(owning_app: 'finder-api', rendering_app: 'finder-frontend', kind: 'finder')
        .and_return(mock_registerer)
      expect(RegisterableSchema).to receive(:new).with(mock_schema).and_return(mock_registerable_schema)
      expect(mock_registerer).to receive(:register).with(mock_registerable_schema)

      PanopticonRegisterer.register(mock_schema)
    end
  end
end