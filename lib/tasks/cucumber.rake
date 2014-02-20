begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:cucumber, 'Run all features') do |t|
    t.fork = true # You may get faster startup if you set this to false
    t.cucumber_opts = 'features --format pretty'
  end
rescue LoadError
end