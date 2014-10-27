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
    maib-reports
    cma-cases
    international-development-funding
    drug-device-alerts
    drug-safety-update
  )

  expect(@fake_panopticon).to have_received(:register).exactly(slugs.size * 2).times
end
