require 'test_helper'
require 'tins/xt'

module Tins
  class AskAndSendTest < Test::Unit::TestCase
    class A
      public

      def foo
        :foo
      end

      def foo_kw(x:)
        [:foo_kw, x]
      end

      def foo_args(*args, &block)
        [:foo_args, args, block&.call]
      end

      private

      def bar
        :bar
      end

      def bar_kw(x:)
        [:bar_kw, x]
      end

      def bar_args(*args, &block)
        [:bar_args, args, block&.call]
      end
    end

    def test_asking_publicly
      assert_equal :foo, A.new.ask_and_send(:foo)
      assert_nil A.new.ask_and_send(:bar)
      assert_nil A.new.ask_and_send(:baz)
    end

    def test_asking_privately
      assert_equal :foo, A.new.ask_and_send!(:foo)
      assert_equal :bar, A.new.ask_and_send!(:bar)
      assert_nil A.new.ask_and_send(:baz)
    end

    def test_asking_selfy_publicly
      a = A.new
      assert_equal :foo, a.ask_and_send_or_self(:foo)
      assert_equal a, a.ask_and_send_or_self(:bar)
      assert_equal a, a.ask_and_send_or_self(:baz)
    end

    def test_asking_selfy_privately
      a = A.new
      assert_equal :foo, a.ask_and_send_or_self!(:foo)
      assert_equal :bar, a.ask_and_send_or_self!(:bar)
      assert_equal a, a.ask_and_send_or_self(:baz)
    end

    def test_asking_publicly_with_kwargs
      assert_equal [:foo_kw, 42], A.new.ask_and_send(:foo_kw, x: 42)
      assert_nil A.new.ask_and_send(:bar_kw, x: 42)
    end

    def test_asking_privately_with_kwargs
      assert_equal [:foo_kw, 42], A.new.ask_and_send!(:foo_kw, x: 42)
      assert_equal [:bar_kw, 42], A.new.ask_and_send!(:bar_kw, x: 42)
    end

    def test_asking_selfy_publicly_with_kwargs
      a = A.new
      assert_equal [:foo_kw, 7], a.ask_and_send_or_self(:foo_kw, x: 7)
      assert_equal a, a.ask_and_send_or_self(:bar_kw, x: 7)
    end

    def test_asking_selfy_privately_with_kwargs
      a = A.new
      assert_equal [:foo_kw, 7], a.ask_and_send_or_self!(:foo_kw, x: 7)
      assert_equal [:bar_kw, 7], a.ask_and_send_or_self!(:bar_kw, x: 7)
    end

    def test_asking_publicly_with_args_and_block
      a = A.new
      assert_equal [:foo_args, [1, 2], :hello], a.ask_and_send(:foo_args, 1, 2) { :hello }
      assert_nil a.ask_and_send(:bar_args, 1, 2) { :hello }
    end

    def test_asking_privately_with_args_and_block
      a = A.new
      assert_equal [:foo_args, [1, 2], :hello], a.ask_and_send!(:foo_args, 1, 2) { :hello }
      assert_equal [:bar_args, [3, 4], :world], a.ask_and_send!(:bar_args, 3, 4) { :world }
    end

    def test_asking_selfy_publicly_with_args_and_block
      a = A.new
      assert_equal [:foo_args, [1], :ok], a.ask_and_send_or_self(:foo_args, 1) { :ok }
      assert_equal a, a.ask_and_send_or_self(:bar_args, 1) { :ok }
    end

    def test_asking_selfy_privately_with_args_and_block
      a = A.new
      assert_equal [:foo_args, [1], :ok], a.ask_and_send_or_self!(:foo_args, 1) { :ok }
      assert_equal [:bar_args, [2], :ok], a.ask_and_send_or_self!(:bar_args, 2) { :ok }
    end
  end
end
