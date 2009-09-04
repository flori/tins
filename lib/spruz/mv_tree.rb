require 'find'
require 'fileutils'

module Spruz
  module MvTree
    include FileUtils

    module_function

    def mv_tree(src, dst, usr = nil, grp = nil, opts = {})
      cd src do
        moved = []
        Find.find('.') do |file|
          next if file == '.'
          usr and grp and chown usr, grp, file, opts
          if File.directory?(file)
            mkdir_p dir = next_file(File.join(dst, file)), opts
            usr and grp and chown usr, grp, dir, opts
          elsif File.file?(file)
            ln file, next_file(File.join(dst, file)), opts
          else
            cp file, next_file(File.join(dst, file)), opts
          end
          moved << file
        end
        moved.each { |file| rm_rf file, opts }
      end
    rescue SystemCallError => e
    end
  end
end
