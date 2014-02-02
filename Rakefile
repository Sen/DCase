require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

# Load custom tasks
Dir['tasks/*.rake'].sort.each { |f| load f }

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = "test/**/*_test.rb"
end

task :default => :test
