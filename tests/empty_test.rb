require 'test_helper'
require 'tins/xt'

module Tins
  class EmptyTest < Test::Unit::TestCase
    class EmptyClass
      def length
        0
      end
    end

    def test_empty
      assert_equal true, EmptyClass.new.empty?
    end

    class NotEmptyClass
      def count
        2
      end
    end

    def test_not_empty
      assert_equal false, NotEmptyClass.new.empty?
      assert_equal false, 23.empty?
    end

    class NotEvenEmptyClass
    end

    def test_not_even_empty
      assert_raise(NoMethodError) do NotEvenEmptyClass.new.empty? end
    end
  end
end
