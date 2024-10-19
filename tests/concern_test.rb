require 'test_helper'

class ConcernTest < Test::Unit::TestCase
  module AC
    extend Tins::Concern

    included do
      $included = self
    end

    prepended do
      $prepended = self
    end

    def foo
      :foo
    end

    class_methods do
      def baz1
        :baz1
      end
    end

    module ClassMethods
      def bar
        :bar
      end
    end

    class_methods do
      def baz2
        :baz2
      end
    end
  end

  $included = nil
  $prepended = nil

  class A
    include AC
  end

  class B
    prepend AC
  end

  def test_concern_include
    a = A.new
    assert_equal A, $included
    assert_equal :foo, a.foo
    assert_equal :bar, A.bar
    assert_equal :baz1, A.baz1
    assert_equal :baz2, A.baz2
    assert_raise(StandardError) do
      AC.module_eval { included {} }
    end
  end

  def test_concern_prepend
    a = B.new
    assert_equal B, $prepended
    assert_equal :foo, a.foo
    assert_equal :bar, B.bar
    assert_equal :baz1, B.baz1
    assert_equal :baz2, B.baz2
    assert_raise(StandardError) do
      AC.module_eval { prepended {} }
    end
  end
end
