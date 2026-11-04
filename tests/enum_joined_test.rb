require 'test_helper'
require 'tins/xt/enum_joined'

module Tins
  class EnumJoinedTest < Test::Unit::TestCase
    def test_empty
      assert_equal '', [].joined
    end

    def test_single_element
      assert_equal 'foo', ['foo'].joined
    end

    def test_two_elements_default
      assert_equal 'foo and bar', %w[foo bar].joined
    end

    def test_three_elements_default
      assert_equal 'foo, bar, and baz', %w[foo bar baz].joined
    end

    def test_four_elements_default
      assert_equal 'a, b, c, and d', %w[a b c d].joined
    end

    def test_custom_two_words_connector
      assert_equal 'foo-bar',
        %w[foo bar].joined(two_words_connector: '-')
    end

    def test_custom_words_connector
      assert_equal 'foo / bar / baz',
        %w[foo bar baz].joined(
          words_connector: ' / ', last_word_connector: ' / '
        )
    end

    def test_custom_last_word_connector
      assert_equal 'foo, barbaz',
        %w[foo bar baz].joined(last_word_connector: '')
    end

    def test_to_s_coercion
      assert_equal '1 and 2.5', [1, 2.5].joined
    end

    def test_range
      assert_equal '1 and 2', (1..2).joined
    end

    def test_custom_enumerable
      enum = Class.new do
        include Enumerable
        def each = %w[x y z].each { |i| yield i }
      end.new
      assert_equal 'x, y, and z', enum.joined
    end
  end
end
