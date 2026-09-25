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

    # --- squeeze with selectors ---

    def test_squeeze_single_value_selector
      assert_equal(
        [1, 3, 2, 2, 4, 6, 3, 7],
        [1, 3, 2, 2, 4, 6, 3, 3, 7].squeeze(3)
      )
    end

    def test_squeeze_multiple_value_selectors
      assert_equal(
        [1, 3, 2, 4, 6, 3, 7],
        [1, 3, 2, 2, 4, 6, 3, 3, 7].squeeze(3, 2)
      )
    end

    def test_squeeze_type_selector
      assert_equal(
        [[1], "1", [1], [1], "1", [1]],
        [[1], '1', [1], [1], '1', '1', [1]].squeeze(String)
      )
    end

    def test_squeeze_multiple_type_selectors
      assert_equal(
        [[1], "1", [1], "1", [1]],
        [[1], '1', [1], [1], '1', '1', [1]].squeeze(String, Array)
      )
    end

    def test_squeeze_range_selector
      # Only 2 and 3 are in range; 5,5 survives (out of scope)
      assert_equal(
        [1, 3, 2, 4, 6, 3, 7, 5, 5, 7],
        [1, 3, 2, 2, 4, 6, 3, 3, 7, 5, 5, 7].squeeze(2..3)
      )
    end

    def test_squeeze_even_block
      assert_equal(
        [1, 3, 2, 4, 6, 3, 3, 7],
        [1, 3, 2, 2, 4, 6, 3, 3, 7].squeeze(&:even?)
      )
    end

    def test_squeeze_odd_block
      assert_equal(
        [1, 3, 2, 2, 4, 6, 3, 7],
        [1, 3, 2, 2, 4, 6, 3, 3, 7].squeeze(&:odd?)
      )
    end

    def test_squeeze_raises_when_both_sels_and_block
      assert_raise(ArgumentError) do
        [1, 1, 2].squeeze(Integer) { |x| true }
      end
    end

    def test_string_array_invariance
      str  = 'fooaabaaz'
      sels = [?a]
      assert_equal str.squeeze(*sels),
                   str.split('').squeeze(*sels).join
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

    # --- squeeze! with selectors ---

    def test_squeeze_bang_with_selector
      a = [1, 3, 2, 2, 4, 6, 3, 3, 7]
      result = a.squeeze!(3)
      assert_equal [1, 3, 2, 2, 4, 6, 3, 7], a
      assert_same a, result
    end

    def test_squeeze_bang_with_selector_no_change
      a = [1, 2, 4, 6, 7]
      assert_nil a.squeeze!(3)
      assert_equal [1, 2, 4, 6, 7], a
    end

    def test_squeeze_bang_with_block
      a = [1, 3, 2, 2, 4, 6, 3, 3, 7]
      result = a.squeeze!(&:even?)
      assert_equal [1, 3, 2, 4, 6, 3, 3, 7], a
      assert_same a, result
    end
  end
end
