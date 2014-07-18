When(/^I run the panopticon:register rake task$/) do
  require "rake"
  @rake = Rake::Application.new
  Rake.application = @rake
  Rake.application.rake_require "tasks/panopticon"
  @rake['panopticon:register'].invoke
end

Then(/^the finders have been registered with panopticon$/) do
  slugs = %w(
    aaib-reports
    cma-cases
    international-development-funding
  )

  slugs.each do |slug|
    expect(PanopticonRegisterer).to(
      have_received(:register).with(hash_including("slug" => slug))
    )
  end
end
