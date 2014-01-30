require 'rake/extensiontask'

def gemspec
  @clean_gemspec ||= eval(File.read(File.expand_path('../../dcase.gemspec', __FILE__)))
end

Rake::ExtensionTask.new('encrypt', gemspec) do |ext|
  ext.ext_dir = 'ext/encrypt'
end
