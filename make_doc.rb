#!/usr/bin/env ruby

$outdir = 'doc/'
puts "Creating documentation in '#$outdir'."
system "rdoc -o #$outdir -m README #{Dir['lib/spruz/**/*.rb'] * ' '}"
