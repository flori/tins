#!/usr/bin/env ruby

$outdir = 'doc/'
puts "Creating documentation in '#$outdir'."
system "rdoc -o #$outdir lib/spruz/*.rb"
