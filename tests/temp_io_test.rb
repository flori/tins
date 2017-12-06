require 'test_helper'
require 'tins/xt/temp_io'

module Tins
  class TempIOTest < Test::Unit::TestCase
    def test_with_string
      returned = temp_io(content: 'foo') { |io|
        assert_equal 'foo', io.read
        :done
      }
      assert_equal returned, :done
    end

    def test_with_suffixed_name
      returned = temp_io(content: 'foo', name: 'foo.csv') { |io|
        assert_true io.path.end_with?('foo.csv')
        :done
      }
      assert_equal returned, :done
    end

    def test_with_proc
      returned = temp_io(content: -> { 'foo' }) { |io|
        assert_equal 'foo', io.read
        :done
      }
      assert_equal returned, :done
    end

    def test_with_proc_and_io_arg
      returned = temp_io(content: -> io { io << 'foo' }) { |io|
        assert_equal 'foo', io.read
        :done
      }
      assert_equal returned, :done
    end
  end
end
