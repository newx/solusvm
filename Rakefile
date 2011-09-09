require 'rubygems'
require 'rake'
require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.test_files = FileList['test/**/test_*.rb']
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

begin
  require 'rdoc/task'
  Rake::RDocTask.new do |rdoc|
    version = Solusvm::VERSION

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "solusvm #{version}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
  task :rdoc do
    abort "rdoc is not available. In order to run rdoc, you must: sudo gem install rdoc"
  end
end

task :default => :test
task :spec => :test
