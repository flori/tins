begin
  require 'rake/gempackagetask'
rescue LoadError
end
require 'rake/clean'
CLEAN.include 'coverage', 'doc'
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
  sh "sdoc -t Spruz -o doc -m README README #{Dir['lib/**/*.rb']} * ' '}"
end

desc "Testing library"
task :test  do
  ENV['RUBYOPT'] = "#{ENV['RUBYOPT']} -Ilib"
  sh 'testrb tests/test_*.rb'
end

desc "Testing library with coverage"
task :coverage  do
  sh "rcov -Ilib -x 'tests/.*\.rb' tests/test_*.rb"
end

if defined? Gem
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
    s.test_files.concat Dir['tests/test_*.rb']

    s.author = "Florian Frank"
    s.email = "flori@ping.de"
    s.homepage = "http://flori.github.com/spruz"
  end

  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
    pkg.package_files += PKG_FILES
  end
end

desc m = "Writing version information for #{PKG_VERSION}"
task :version do
  puts m
  File.open(File.join('lib', PKG_NAME, 'version.rb'), 'w') do |v|
    v.puts <<EOT
module Spruz
  # Spruz version
  VERSION         = '#{PKG_VERSION}'
  VERSION_ARRAY   = VERSION.split(/\\./).map { |x| x.to_i } # :nodoc:
  VERSION_MAJOR   = VERSION_ARRAY[0] # :nodoc:
  VERSION_MINOR   = VERSION_ARRAY[1] # :nodoc:
  VERSION_BUILD   = VERSION_ARRAY[2] # :nodoc:
end
EOT
  end
end

desc "Default task: write version and test"
task :default => [ :version, :test ]

desc "Prepare a release"
task :release => [ :clean, :version, :package ]
