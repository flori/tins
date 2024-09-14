require 'test_helper'
require 'tins'

module Tins
  class DeprecateTest < Test::Unit::TestCase
    class A < Array
      attr_reader :warned

      def warn(msg)
        @warned = msg =~ /DEPRECATION/
      end

      extend Tins::Deprecate
      deprecate method:
        def zum_felde
          to_a
        end,
        new_method: :to_a
    end

    def test_deprecate
      a = A[ 1, 2 ]
      assert_nil a.warned
      assert_equal a.zum_felde, [ 1, 2 ]
      assert a.warned
    end
  end
end
