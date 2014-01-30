task :gem do
  `gem build ./dcase.gemspec`
end

task :install do
  `gem install ./dcase-#{DCase::VERSION}.gem`
end
