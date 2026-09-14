require 'test_helper'
require 'tins/xt/expose'

module Tins
  class ExposeTest < Test::Unit::TestCase
    class A
      def priv
        :priv
      end
      private :priv

      def prot(x)
        :prot
      end
      protected :prot

      def with_kw(x:)
        [:with_kw, x]
      end
      private :with_kw

      def with_block
        yield :from_block
      end
      private :with_block
    end

    def setup
      @a = A.new
    end

    def test_raises_exception_unless_exposed
      assert_raise(NoMethodError) { @a.priv }
      assert_raise(NoMethodError) { @a.prot(:any) }
    end

    def test_exposes_all_methods
      @a = @a.expose
      assert_equal :priv, @a.priv
      assert_equal :prot, @a.prot(:any)
    end

    def test_exposes_all_methods_in_block
      assert_equal :priv, @a.expose { priv }
      assert_equal :prot, @a.expose { prot(:any) }
    end

    def test_exposes_specified_method_call
      assert_equal :priv, @a.expose(:priv)
      assert_equal :prot, @a.expose(:prot, :any)
    end

    def test_exposes_method_with_kwargs
      assert_equal [:with_kw, 42], @a.expose(:with_kw, x: 42)
    end

    def test_exposes_method_with_block
      assert_equal :from_block, @a.expose(:with_block) { |v| v }
    end

    def test_exposes_method_with_kwargs_and_block
      assert_equal [:with_kw, 7], @a.expose(:with_kw, x: 7) { :ignored }
    end
  end
end
