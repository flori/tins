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
  sh "rcov -Ilib -x 'tests/.*\.rb' tests/test_spruz.rb"
end

desc "Clean created files"
task :clean do
  %w[doc coverage].each { |file| rm_r file, :force => true }
end

desc "Prepare a release"
task :release => [ :clean, :package ]

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = "Useful stuff."
  s.description = "All the stuff that isn't good/big enough for a real library."

  s.files = PKG_FILES

  s.require_path = 'lib'

  s.bindir = "bin"
  s.executables << "enum"

  s.has_rdoc = true
  s.extra_rdoc_files << 'README'
  s.rdoc_options << '--title' <<  'Spruz' << '--main' << 'README'
  s.test_files << 'tests/test_spruz.rb'

  s.author = "Florian Frank"
  s.email = "flori@ping.de"
  s.homepage = "http://flori.github.com/spruz"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
  pkg.package_files += PKG_FILES
end
