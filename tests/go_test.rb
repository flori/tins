require 'test_helper'
require 'tins/go'

module Tins
  class GoTest < Test::Unit::TestCase
    include Tins::GO


    def test_empty_string
      r = go '', %w[a b c]
      assert_equal({}, r)
    end

    def test_empty_args
      r = go 'ab:', []
      assert_equal({ 'a' => false, 'b' => nil }, r)
    end

    def test_simple
      r = go 'ab:', %w[-b hello -a -c]
      assert_equal({ 'a' => 1, 'b' => 'hello' }, r)
    end

    def test_complex
      r = go 'ab:', %w[-a -b hello -a -bworld -c]
      assert_equal({ 'a' => 2, 'b' => 'hello' }, r)
      assert_equal %w[hello world], r['b'].to_a
    end

    def test_complex2
      r = go 'ab:', %w[-b hello -aa -b world -c]
      assert_equal({ 'a' => 2, 'b' => 'hello' }, r)
      assert_equal %w[hello world], r['b'].to_a
    end

    def test_complex_frozen
      args = %w[-b hello -aa -b world -c]
      args = args.map(&:freeze)
      r = go 'ab:', args
      assert_equal({ 'a' => 2, 'b' => 'hello' }, r)
      assert_equal %w[hello world], r['b'].to_a
    end
  end
end
