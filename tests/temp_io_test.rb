require 'test_helper'
require 'tins/xt/temp_io'

module Tins
  class TempIOTest < Test::Unit::TestCase
    def test_with_string
      returned = temp_io('foo') { |io|
        assert_equal 'foo', io.read
        :done
      }
      assert_equal returned, :done
    end

    def test_with_proc
      returned = temp_io(-> { 'foo' }) { |io|
        assert_equal 'foo', io.read
        :done
      }
      assert_equal returned, :done
    end
  end
end
