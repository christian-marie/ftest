# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
	Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
	$stderr.puts e.message
	$stderr.puts "Run `bundle install` to install missing gems"
	exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
	gem.name = "ftest"
	gem.homepage = "http://github.com/christian-marie/ftest"
	gem.license = 'MIT'
	gem.summary = 'Ruby fuzz testing'
	gem.description = 'Simple and flexible ruby fuzz testing DSL'
	gem.email = "pingu@anchor.net.au"
	gem.authors = ["Christian Marie"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
	version = File.exist?('VERSION') ? File.read('VERSION') : ""

	rdoc.rdoc_dir = 'rdoc'
	rdoc.title = "ftest #{version}"
	rdoc.rdoc_files.include('README*')
	rdoc.rdoc_files.include('lib/**/*.rb')
end
