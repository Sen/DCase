require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

# Load custom tasks
Dir['tasks/*.rake'].sort.each { |f| load f }

Rake::TestTask.new do |task|
  task.libs << 'test'
end

task :default => :test
