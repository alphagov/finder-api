require 'gds_api/panopticon'
require 'presenters/schema_artefact_presenter'
require 'presenters/finder_signup_artefact_presenter'

class PanopticonRegisterer
  def initialize(schemae)
    @schemae = schemae
  end

  def call
    schemae.each do |metadata|
      register_schema(metadata)
      register_signup(metadata)
    end
  end

private
  attr_reader :schemae

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
