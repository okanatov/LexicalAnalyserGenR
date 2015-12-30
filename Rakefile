require 'rake'
require 'rake/testtask'
require 'rubocop/rake_task'

task default: %w(test)

Rake::TestTask.new do |t|
  t.pattern = 'test/test_*.rb'
end

RuboCop::RakeTask.new
