require 'test_helper'
require 'tins/xt/enum_squeeze'

module Tins
  class EnumSqueezeTest < Test::Unit::TestCase
    # --- squeeze (non-bang) ---

    def test_basic
      assert_equal [1, 2, 3, 1], [1, 1, 2, 2, 3, 1].squeeze
    end

    def test_non_consecutive_duplicates_survive
      assert_equal [1, 2, 1, 2, 1], [1, 2, 1, 2, 1].squeeze
    end

    def test_all_same_element
      assert_equal [7], [7, 7, 7, 7].squeeze
    end

    def test_single_element
      assert_equal [42], [42].squeeze
    end

    def test_empty
      assert_equal [], [].squeeze
    end

    def test_no_duplicates
      assert_equal [1, 2, 3], [1, 2, 3].squeeze
    end

    def test_returns_new_array
      a = [1, 1, 2]
      b = a.squeeze
      refute_same a, b
      assert_equal [1, 1, 2], a
    end

    def test_equality_semantics
      # 1 == 1.0 is true, so the second is collapsed
      assert_equal [1, 2], [1, 1.0, 2].squeeze
    end

    def test_works_on_range
      assert_equal [1, 2, 3], (1..3).to_a.squeeze
    end

    def test_works_on_lazy_enumerable
      result = [1, 1, 2, 2, 3].lazy.map { |x| x }.squeeze
      assert_equal [1, 2, 3], result
    end

    # --- squeeze! (bang) ---

    def test_squeeze_bang_modifies_in_place
      a = [1, 1, 2, 2, 3, 1]
      a.squeeze!
      assert_equal [1, 2, 3, 1], a
    end

    def test_squeeze_bang_returns_self_when_changed
      a = [1, 1, 2]
      result = a.squeeze!
      assert_same a, result
    end

    def test_squeeze_bang_returns_nil_when_unchanged
      a = [1, 2, 3]
      assert_nil a.squeeze!
      assert_equal [1, 2, 3], a
    end

    def test_squeeze_bang_empty_array
      a = []
      assert_nil a.squeeze!
      assert_equal [], a
    end

    def test_squeeze_bang_raises_without_replace
      enum = [1, 1, 2].each # Enumerator has no #replace
      assert_raise(RuntimeError) { enum.squeeze! }
    end
  end
end
