require "spec_helper"

require "services/find_case"

describe FindCase do
  subject(:service) {
    FindCase.new(cases_repository, case_formatter, context)
  }

  let(:cases_repository)  { double(:cases_repository, :find_by => matching_cases) }
  let(:case_formatter)    { double(:case_formatter, :call => formatted_case) }
  let(:context)           { double(:context, success: nil, params: params) }
  let(:params)            { {} }
  let(:matching_cases)    { [matching_case] }
  let(:matching_case)     { double(:matching_case) }
  let(:formatted_case)    { double(:formatted_case, :to_h => case_as_a_hash) }
  let(:case_as_a_hash)    { double(:case_formatter) }

  describe do
    context "searching with simple criteria" do
      let(:criteria) { { "opened_date" => "2005" } }

      before do
        params.merge!(criteria)
      end

      it "delegates search to the cases repository" do
        service.call

        expect(cases_repository).to have_received(:find_by).with(criteria)
      end

      it "formats the matching cases" do
        service.call

        expect(case_formatter).to have_received(:call).with(matching_case)
      end

      it "passes the results to the context" do
        service.call

        expect(context).to have_received(:success).with(
          :results => [ case_as_a_hash ],
        )
      end
    end
  end
end
