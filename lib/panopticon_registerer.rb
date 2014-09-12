require 'gds_api/panopticon'

class PanopticonRegisterer
  def self.register(registerables)
    registerer = GdsApi::Panopticon::Registerer.new(owning_app: 'finder-api', rendering_app: 'finder-frontend', kind: 'finder')

    registerables.each do |registerable|
      registerer.register(registerable)
    end
  end
end
