require 'rubygems'
require 'rake'
require 'redgreen'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "solusvm"
    gem.summary = "Wrapper for the SolusVM Admin::API"
    gem.description = "Solusvm allows for easy interaction with the SolusVM Admin::API."
    gem.email = "jmazzi@gmail.com"
    gem.homepage = "http://www.site5.com"
    gem.authors = ["Justin Mazzi"]
    gem.add_dependency 'xml-simple'
    gem.add_development_dependency 'redgreen'
    gem.add_development_dependency 'fakeweb'
    gem.rubyforge_project = 'solusvm'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
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

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "solusvm #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
