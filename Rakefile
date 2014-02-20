begin
  require 'cucumber/rake/task'
  require 'rspec/core/rake_task'

  Cucumber::Rake::Task.new(:cucumber, 'Run all features') do |t|
    t.fork = true # You may get faster startup if you set this to false
    t.cucumber_opts = 'features --format pretty'
  end

  RSpec::Core::RakeTask.new(:spec)

  task :default => [:spec, :cucumber]
rescue LoadError
end