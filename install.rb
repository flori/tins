#!/usr/bin/env ruby

require 'rbconfig'
require 'fileutils'
include FileUtils::Verbose

include Config

src = File.join(*%w[lib spruz])
dst = File.join(CONFIG["sitelibdir"], 'spruz')
mkdir_p dst
for file in Dir[src]
  install file, File.join(dst, file)
end
install 'bin/enum', File.join(CONFIG['bindir'], 'enum')
