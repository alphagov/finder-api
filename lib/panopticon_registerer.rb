require 'registerable_schema'
require 'gds_api/panopticon'

class PanopticonRegisterer
  def self.register(schema)
    registerer = GdsApi::Panopticon::Registerer.new(owning_app: 'finder-api', rendering_app: 'finder-frontend', kind: 'finder')
    registerer.register(RegisterableSchema.new(schema))
  end
end