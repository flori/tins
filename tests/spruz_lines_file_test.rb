#!/usr/bin/env ruby

require 'test/unit'
require 'tempfile'
require 'spruz/lines_file'

module Spruz
  class SpruzLinesFileTest < Test::Unit::TestCase
    FILE = <<EOT
def foo
end

def bar
end

def baz
end
EOT

    def test_instantiation
      write_file do |file|
        file.write FILE
        file.rewind
        assert_kind_of Spruz::LinesFile, lf = Spruz::LinesFile.for_file(file)
        assert_equal [ "def foo\n", 1 ], [ lf.line, lf.line.line_number ]
        assert_kind_of Spruz::LinesFile, lf = Spruz::LinesFile.for_filename(file.path)
        assert_equal [ "def foo\n", 1 ], [ lf.line, lf.line.line_number ]
        file.rewind
        assert_kind_of Spruz::LinesFile, lf = Spruz::LinesFile.for_lines(file.readlines)
        assert_equal [ "def foo\n", 1 ], [ lf.line, lf.line.line_number ]
      end
    end

    def test_match
      write_file do |file|
        file.write FILE
        file.rewind
        lf = Spruz::LinesFile.for_file(file)
        assert_equal "def foo\n", lf.line
        assert_equal %w[foo], lf.match_forward(/def (\S+)/)
        assert_equal "def foo\n", lf.line
        assert_equal %w[foo], lf.match_forward(/def (\S+)/, true)
        assert_equal "end\n", lf.line
        assert_equal %w[bar], lf.match_forward(/def (\S+)/, true)
        assert_equal %w[baz], lf.match_forward(/def (\S+)/, true)
        assert_nil   lf.match_forward(/def (\S+)/, true)
        assert_equal "end\n", lf.line
        assert_equal 8, lf.line.line_number
      end
    end

    private

    def write_file
      File.open(File.join(Dir.tmpdir, "temp.#$$"), 'wb+') do |file|
        yield file
      end
    end
  end
end
