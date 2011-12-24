require 'enumerator'
require 'tins/module_group'

module Tins
  module Find
    EXPECTED_STANDARD_ERRORS = ModuleGroup[
      Errno::ENOENT, Errno::EACCES, Errno::ENOTDIR, Errno::ELOOP,
      Errno::ENAMETOOLONG
    ]

    class Finder
      def initialize(opts = {})
        @show_hidden     = opts.fetch(:show_hidden)     { true }
        @raise_errors    = opts.fetch(:raise_errors)    { false }
        @follow_symlinks = opts.fetch(:follow_symlinks) { true }
      end

      attr_reader :show_hidden

      attr_reader :raise_errors

      attr_reader :follow_symlinks

      def find(*paths)
        block_given? or return enum_for(__method__, *paths)
        paths.collect! { |d| d.dup }
        while path = paths.shift
          path = prepare_path(path)
          catch(:prune) do
            path.stat or next
            yield path
            if path.stat.directory?
              begin
                ps = Dir.entries(path)
              rescue EXPECTED_STANDARD_ERRORS
                @raise_errors ? raise : next
              end
              ps.sort!
              ps.reverse_each do |p|
                next if p == "." or p == ".."
                next if !@show_hidden && p.start_with?('.')
                p = File.join(path, p)
                paths.unshift p.untaint
              end
            end
          end
        end
      end

      private

      def prepare_path(path)
        path = path.dup.taint
        path.extend PathExtension
        path.finder = self
        path
      end
    end

    module PathExtension
      attr_accessor :finder

      def stat
        begin
          @stat ||=
            if finder.follow_symlinks
              File.stat(self)
            else
              File.lstat(self)
            end
        rescue EXPECTED_STANDARD_ERRORS
          if finder.raise_errors
            raise
          end
        end
      end

      def file
        if stat.file?
          File.new(self)
        end
      end
    end

    #
    # Calls the associated block with the name of every path and directory
    # listed as arguments, then recursively on their subdirectories, and so on.
    #
    # See the +Find+ module documentation for an example.
    #
    def find(*paths, &block) # :yield: path
      opts = Hash === paths.last ? paths.pop : {}
      Finder.new(opts).find(*paths, &block)
    end

    #
    # Skips the current path or directory, restarting the loop with the next
    # entry. If the current path is a directory, that directory will not be
    # recursively entered. Meaningful only within the block associated with
    # Find::find.
    #
    # See the +Find+ module documentation for an example.
    #
    def prune
      throw :prune
    end

    module_function :find, :prune
  end
end
