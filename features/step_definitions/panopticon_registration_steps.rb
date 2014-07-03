When(/^I run the panopticon:register rake task$/) do
  require "rake"
  @rake = Rake::Application.new
  Rake.application = @rake
  Rake.application.rake_require "tasks/panopticon"
  @rake['panopticon:register'].invoke
end

Then(/^the finders have been registered with panopticon$/) do
  expect(PanopticonRegisterer).to have_received(:register).twice
end
