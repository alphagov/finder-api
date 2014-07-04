require "spec_helper"

require "services/find_document"

describe FindDocument do
  subject(:service) {
    FindDocument.new(repository, formatter, context)
  }

  let(:repository)          { double(:repository, :find_by => matching_documents) }
  let(:formatter)           { double(:formatter, :call => formatted_document) }
  let(:context)             { double(:context, success: nil, params: params) }
  let(:params)              { { "finder_type" => finder_type } }
  let(:finder_type)         { "cma-cases" }
  let(:matching_documents)  { [matching_document] }
  let(:matching_document)   { double(:matching_document) }
  let(:formatted_document)  { double(:formatted_document, :to_h => document_as_a_hash) }
  let(:document_as_a_hash)  { double(:formatter) }

  describe do
    context "searching with simple criteria" do
      let(:criteria) { { "opened_date" => "2005" } }

      before do
        params.merge!(criteria)
      end

      it "delegates search to the documents repository" do
        service.call

        expect(repository).to have_received(:find_by).with(finder_type, criteria)
      end

      it "formats the matching documents" do
        service.call

        expect(formatter).to have_received(:call).with(matching_document)
      end

      it "passes the results to the context" do
        service.call

        expect(context).to have_received(:success).with(
          :results => [ document_as_a_hash ],
        )
      end
    end
  end
end
