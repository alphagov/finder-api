require 'gds_api/panopticon'
require 'presenters/schema_artefact_presenter'
require 'presenters/finder_signup_artefact_presenter'

class PanopticonRegisterer
  class << self
    def register(schemae)
      schemae.each do |metadata|
        register_schema(metadata)
        register_signup(metadata)
      end
    end

    def register_schema(metadata)
      schema_registerer.register(SchemaArtefactPresenter.new(metadata))
    end

    def register_signup(metadata)
      signup_registerer.register(FinderSignupArtefactPresenter.new(metadata))
    end

    def schema_registerer
      @schema_registerer ||= GdsApi::Panopticon::Registerer.new(owning_app: 'finder-api', rendering_app: 'finder-frontend', kind: 'finder')
    end

    def signup_registerer
      @signup_registerer ||= GdsApi::Panopticon::Registerer.new(owning_app: 'finder-api', rendering_app: 'finder-frontend', kind: 'finder_email_signup')
    end
  end
end
