require 'test_helper'
require 'tins'

module Tins
  class NullTest < Test::Unit::TestCase
    require 'tins/xt/null'

    def test_null
      assert_equal NULL, NULL.foo
      assert_equal NULL, NULL.foo.bar
      assert_equal 'NULL', NULL.inspect
      assert_equal '', NULL.to_s
      assert_equal 1, Null(1)
      assert_equal NULL, Null(nil)
      assert_equal NULL, NULL::NULL
      assert NULL.nil?
    end
  end
end
