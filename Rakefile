require 'rake/gempackagetask'
require 'rbconfig'

include Config

PKG_NAME = 'spruz'
PKG_VERSION = File.read('VERSION').chomp
PKG_FILES = FileList['**/*'].exclude(/(CVS|\.svn|pkg|coverage|doc)/)

desc "Installing library"
task :install  do
  ruby 'install.rb'
end

desc "Creating documentation"
task :doc do
  ruby 'make_doc.rb'
end

desc "Testing library"
task :test  do
  ruby '-Ilib tests/test_spruz.rb'
end

desc "Testing library with coverage"
task :coverage  do
  sh 'rcov -Ilib tests/test_spruz.rb'
end

desc "Clean created files"
task :clean do
  %w[doc coverage].each { |file| rm_r file, :force => true }
end

desc "Prepare a release"
task :release => [ :clean, :package ]

spec = Gem::Specification.new do |s|
  #### Basic information.

  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = "Useful stuff."
  s.description = "All the stuff that isn't good/big enough for a real library."
  #### Dependencies and requirements.

  #s.add_dependency('log4r', '> 1.0.4')
  #s.requirements << ""

  s.files = PKG_FILES

  #### C code extensions.

  #s.extensions << "ext/extconf.rb"

  #### Load-time details: library and application (you will need one or both).

  s.require_path = 'lib'                         # Use these for libraries.
  #s.autorequire = 'spruz'

  s.bindir = "bin"                              # Use these for applications.
  s.executables = ["enum"]
  #s.default_executable = "bla.rb"

  #### Documentation and testing.

  s.has_rdoc = true
  #s.extra_rdoc_files = rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a
  #s.rdoc_options <<
  #  '--title' <<  'Rake -- Ruby Make' <<
  #  '--main' << 'README' <<
  #  '--line-numbers'
  s.test_files << 'tests/test_spruz.rb'

  #### Author and project details.

  s.author = "Florian Frank"
  s.email = "flori@ping.de"
  s.homepage = "http://lab.ping.de"
  #s.rubyforge_project = "spruz"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
  pkg.package_files += PKG_FILES
end
