require 'test_helper'
require 'tins/xt'
require 'set'

module Tins
  class BlankFullTest < Test::Unit::TestCase

    def test_blank
      assert !true.blank?
      assert false.blank?
      assert nil.blank?
      assert [].blank?
      assert ![23].blank?
      assert Set[].blank?
      assert !Set[23].blank?
      assert({}.blank?)
      assert !{ :foo => 23 }.blank?
      assert "".blank?
      assert "   ".blank?
      assert !"foo".blank?
    end

    def test_full
      assert_equal true, true.full?
      assert_nil false.full?
      assert_nil nil.full?
      assert_nil [].full?
      assert_equal [ 23 ], [ 23 ].full?
      assert_nil Set[].full?
      assert_equal Set[23], Set[23].full?
      assert_nil({}.full?)
      assert_equal({ :foo => 23 }, { :foo => 23 }.full?)
      assert_nil "".full?
      assert_nil "   ".full?
      assert_equal "foo", "foo".full?
      assert_nil "    ".full?(&:size)
      assert_equal 3, "foo".full?(&:size)
      assert_nil "    ".full?(&:size)
      assert_equal 3, "foo".full?(&:size)
      assert_nil "    ".full?(:size)
      assert_equal 3, "foo".full?(:size)
      assert_nil "    ".full?(:size)
      assert_equal 3, "foo".full?(:size)
    end
  end
end
