#!/usr/bin/env ruby

require 'rbconfig'
include Config
require 'fileutils'
include FileUtils::Verbose

if $DEBUG
  def install(*a)
    p [ :install ] + a
  end

  def mkdir_p(*a)
    p [ :mkdir_p ] + a
  end
end

file = File.join('lib', 'spruz.rb')
dst = CONFIG["sitelibdir"]
install file, File.join(dst, File.join('lib/spruz.rb'))
src = File.join(*%w[lib spruz *.rb])
dst = File.join(CONFIG["sitelibdir"], 'spruz')
mkdir_p dst
for file in Dir[src]
  install file, File.join(dst, file)
end
src = File.join(*%w[lib spruz xt *.rb])
dst = File.join(CONFIG["sitelibdir"], 'spruz', 'xt')
mkdir_p dst
for file in Dir[src]
  install file, File.join(dst, file)
end
install 'bin/enum', File.join(CONFIG['bindir'], 'enum')
