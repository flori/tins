#!/usr/bin/env ruby

require 'test/unit'
require 'spruz'

module Spruz
  class MinimizeTest < Test::Unit::TestCase
    class ::Array
      include Spruz::Minimize
    end

    def test_minimize
      assert_equal [], [].minimize
      assert_equal [ 1..1 ], [ 1 ].minimize
      assert_equal [ 1..2 ], [ 1, 2 ].minimize
      assert_equal [ 1..1, 7..7 ], [ 1, 7 ].minimize
      assert_equal [ 1..3, 7..7, 11..14 ],
        [ 1, 2, 3, 7, 11, 12, 13, 14 ].minimize
      assert_equal [ 'A'..'C', 'G'..'G', 'K'..'M' ],
        [ 'A', 'B', 'C', 'G', 'K', 'L', 'M' ].minimize
    end

    def test_minimize!
      assert_equal [], [].minimize!
      assert_equal [ 1..1 ], [ 1 ].minimize!
      assert_equal [ 1..2 ], [ 1, 2 ].minimize!
      assert_equal [ 1..1, 7..7 ], [ 1, 7 ].minimize!
      assert_equal [ 1..3, 7..7, 11..14 ],
        [ 1, 2, 3, 7, 11, 12, 13, 14 ].minimize!
      assert_equal [ 'A'..'C', 'G'..'G', 'K'..'M' ],
        [ 'A', 'B', 'C', 'G', 'K', 'L', 'M' ].minimize!
    end

    def test_unminimize
      assert_equal [], [].unminimize
      assert_equal [ 1 ], [ 1..1 ].unminimize
      assert_equal [ 1, 2 ], [ 1..2 ].unminimize
      assert_equal [ 1, 7 ], [ 1..1, 7..7 ].unminimize
      assert_equal [ 1, 2, 3, 7, 11, 12, 13, 14 ],
        [ 1..3, 7..7, 11..14 ].unminimize
      assert_equal [ 'A', 'B', 'C', 'G', 'K', 'L', 'M' ],
        [ 'A'..'C', 'G'..'G', 'K'..'M' ].unminimize
    end

    def test_unminimize!
      assert_equal [], [].unminimize!
      assert_equal [ 1 ], [ 1..1 ].unminimize!
      assert_equal [ 1, 2 ], [ 1..2 ].unminimize!
      assert_equal [ 1, 7 ], [ 1..1, 7..7 ].unminimize!
      assert_equal [ 1, 2, 3, 7, 11, 12, 13, 14 ],
        [ 1..3, 7..7, 11..14 ].unminimize!
      assert_equal [ 'A', 'B', 'C', 'G', 'K', 'L', 'M' ],
        [ 'A'..'C', 'G'..'G', 'K'..'M' ].unminimize!
    end
  end

  class PartialApplicationTest < Test::Unit::TestCase
    require 'spruz/xt/partial_application'

    def mul(x, y) x * y end

    define_method(:dup) { |y| method(:mul).partial(2)[y] }

    define_method(:trip) { |y| method(:mul).partial(3)[y] }


    def test_proc
      mul   = lambda { |x, y| x * y }
      klon  = mul.partial
      dup   = mul.partial(2)
      trip  = mul.partial(3)
      assert_equal [ 6, 9, 12 ], [ dup[3], trip[3], mul[4, 3] ]
      assert_equal [ 6, 9, 12 ], [ dup[3], trip[3], klon[4, 3] ]
      assert_raises(ArgumentError) do
        mul.partial(1, 2, 3)
      end
    end

    def test_method
      assert_equal [ 6, 9, 12 ], [ dup(3), trip(3), mul(4, 3) ]
    end
  end

  class GeneratorTest < Test::Unit::TestCase
    def setup
      @numeric = [ 1, 2, 3 ]
      @string  = %w[a b c]
      @chars   = 'abc'
    end

    def test_generator
      g = Spruz::Generator[@numeric, @string]
      assert_equal 2, g.size
      g.add_dimension(@chars, :each_byte)
      assert_equal 3, g.size
      assert_equal\
        [[1, "a", 97],
        [1, "a", 98],
        [1, "a", 99],
        [1, "b", 97],
        [1, "b", 98],
        [1, "b", 99],
        [1, "c", 97],
        [1, "c", 98],
        [1, "c", 99],
        [2, "a", 97],
        [2, "a", 98],
        [2, "a", 99],
        [2, "b", 97],
        [2, "b", 98],
        [2, "b", 99],
        [2, "c", 97],
        [2, "c", 98],
        [2, "c", 99],
        [3, "a", 97],
        [3, "a", 98],
        [3, "a", 99],
        [3, "b", 97],
        [3, "b", 98],
        [3, "b", 99],
        [3, "c", 97],
        [3, "c", 98],
        [3, "c", 99]], g.to_a
    end
  end

  class RoundTest < Test::Unit::TestCase
    require 'spruz/xt/round'

    def test_standard
      assert_equal(1, 1.round)
      assert_equal(-1, -1.round)
      assert_equal(2, 1.5.round)
      assert_kind_of Integer, 1.5.round
      assert_equal(-1, -1.4.round)
      assert_equal(-2, -1.5.round)
    end

    def test_inclusion
      assert_equal(10, 12.round(-1))
      assert_kind_of Integer, 12.round(-1)
      assert_equal(-10, -12.round(-1))
      assert_raises(ArgumentError) { 12.round(-2) }
      assert_raises(ArgumentError) { -12.round(-2) }
      assert_in_delta(1.6, 1.55.round(1), 1E-1)
      assert_kind_of Float, 1.55.round(1)
      assert_equal(2, 1.55.round(0))
      assert_in_delta(-1.5, -1.45.round(1), 1E-1)
      assert_equal(-1, -1.45.round(0))
      assert_in_delta(-1.6, -1.55.round(1), 1E-1)
      assert_equal(-2, -1.55.round(0))
      assert_in_delta(-1.55, -1.55.round(999), 1E-2)
    end
  end

  class ModuleGroupTest < Test::Unit::TestCase
    MyClasses = Spruz::ModuleGroup[ Array, String, Hash ]

    def test_module_group
      assert MyClasses === []
      assert MyClasses === ""
      assert MyClasses === {}
      assert !(MyClasses === :nix)
      case []
      when MyClasses
        assert true
      when Array
        assert false
      end
      case :nix
      when MyClasses
        assert false
      when Array
        assert false
      when Symbol
        assert true
      end
    end
  end

  class UniqByTest < Test::Unit::TestCase
    require 'spruz/xt/uniq_by'

    class Point < Struct.new :x, :y
    end

    def test_uniq_by
      assert_equal [ 1, 2, 3 ], [ 1, 2, 2, 3 ].uniq_by
      assert_equal [ 1, 2, 3 ], [ 1, 2, 2, 3 ].uniq_by!
      p1 = Point.new 1, 2
      p2 = Point.new 2, 2
      p3 = Point.new 2, 2
      p4 = Point.new 3, 3
      a = [ p1, p2, p3, p4 ]
      a_uniq = a.uniq_by { |p| p.y }
      assert_equal 2, a_uniq.size
      assert a_uniq.include?(p4)
      assert [ p1, p2, p3 ].any? { |p| a_uniq.include? p }
      a.uniq_by! { |p| p.y }
      assert_equal 2, a.size
      assert a.include?(p4)
      assert [ p1, p2, p3 ].any? { |p| a.include? p }
    end
  end

  class CountByTest < Test::Unit::TestCase
    require 'spruz/xt/count_by'

    def test_count_by
      assert_equal 0, [].count_by { |x| x % 2 == 0 }
      assert_equal 0, [ 1 ].count_by { |x| x % 2 == 0 }
      assert_equal 1, [ 1 ].count_by { |x| x % 2 == 1 }
      assert_equal 1, [ 1, 2 ].count_by { |x| x % 2 == 0 }
      assert_equal 1, [ 1, 2 ].count_by { |x| x % 2 == 1 }
      assert_equal 2, [ 1, 2, 3, 4, 5 ].count_by { |x| x % 2 == 0 }
      assert_equal 3, [ 1, 2, 3, 4, 5 ].count_by { |x| x % 2 == 1 }
    end
  end

  if Spruz::Shuffle === Array
    class ShuffleTest < Test::Unit::TestCase
      require 'spruz/xt/shuffle'

      def setup
        @a = [ 1, 2, 3 ]
        srand 666
      end

      def test_shuffle
        assert_equal(a = [2, 3, 1], a = @a.shuffle)
        assert_not_same @a, a
        assert_equal(b = [3, 1, 2], b = @a.shuffle)
        assert_not_same a, b
        assert_not_same @a, b
      end

      def test_shuffle_bang
        assert_equal([2, 3, 1], a = @a.shuffle!)
        assert_same @a, a
        assert_equal([1, 2, 3], b = @a.shuffle!)
        assert_same a, b
        assert_same @a, b
      end
    end
  end

  class LimitedTest < Test::Unit::TestCase
    class ::Array
      include Spruz::Shuffle
    end

    def test_limited
      count = {}
      limited = Spruz::Limited.new(5)
      5.times do
        limited.execute do
          count[Thread.current] = true
          sleep
        end
      end
      until count.size >= 5
        sleep 0.1
      end
      assert_equal 5, count.keys.uniq.size
    end
  end

  class MemoizeTest < Test::Unit::TestCase
    class A
      def initialize(var)
        @var = var
      end

      def foo(n)
        r = n * @var
        @var += 1
        r
      end
      memoize_method :foo

      def bar(n)
        r = n * @var
        @var += 1
        r
      end
      memoize_function :bar
    end

    def setup
      @a23 = A.new(23)
      @a42 = A.new(42)
    end

    def test_memoize_method
      assert Module.__memoize_cache__.empty?
      assert_equal 2 * 23, @a23.foo(2)
      assert_equal 2 * 23, @a23.foo(2)
      assert_equal 3 * 24, @a23.foo(3)
      assert_equal 2 * 42, @a42.foo(2)
      assert_equal 2 * 42, @a42.foo(2)
      assert_equal 3 * 43, @a42.foo(3)
      assert !Module.__memoize_cache__.empty?
      @a23, @a42 = nil, nil
      GC.start
      # XXX test fails atm, assert Module.__memoize_cache__.empty?
    end

    def test_memoize_function
      assert A.__memoize_cache__.empty?
      assert_equal 2 * 23, @a23.bar(2)
      assert_equal 2 * 23, @a23.bar(2)
      assert_equal 3 * 24, @a23.bar(3)
      assert_equal 2 * 23, @a42.bar(2)
      assert_equal 2 * 23, @a42.bar(2)
      assert_equal 3 * 24, @a42.bar(3)
      assert !A.__memoize_cache__.empty?
    end
  end

  class HashUnionTest < Test::Unit::TestCase
    require 'spruz/xt/hash_union'

    class HashLike1
      def to_hash
        { 'foo' => true }
      end
    end

    class HashLike2
      def to_h
        { 'foo' => true }
      end
    end

    def test_union
      defaults = { 'foo' => true, 'bar' => false, 'quux' => nil }
      hash = { 'foo' => false }
      assert_equal [ ['bar', false], ['foo', false], ['quux', nil] ],
        (hash | defaults).sort
      hash |= defaults
      assert_equal [ ['bar', false], ['foo', false], ['quux', nil] ],
        hash.sort
      hash = { 'foo' => false }
      hash |= {
        'quux' => true,
        'baz' => 23,
      } | defaults
      assert_equal [ ['bar', false], [ 'baz', 23 ], ['foo', false],
        ['quux', true] ],
        hash.sort
    end

    def test_hash_conversion
      assert_equal({ 'foo' => true }, { } | HashLike1.new)
      assert_equal({ 'foo' => true }, { } | HashLike2.new)
    end
  end

  class HashSymbolizeKeysRecursiveTest < Test::Unit::TestCase
    require 'spruz/xt/hash_symbolize_keys_recursive'

    def test_symbolize
      hash = {
        'key' => [
          {
            'key' => {
              'key' => true
            }
          }
        ],
      }
      hash2 = hash.symbolize_keys_recursive
      assert hash2[:key][0][:key][:key]
      hash.symbolize_keys_recursive!
      assert hash[:key][0][:key][:key]
    end
  end

  class SubhashTest < Test::Unit::TestCase
    require 'spruz/xt/subhash'

    def test_subhash
      h = { 'foo1' => 1, 'foo2' => 2, 'bar666' => 666 }
      assert_equal [ [ 'bar666', 666 ] ], h.subhash(/\Abar/).to_a
      assert h.subhash(/\Abaz/).empty?
      assert_equal [ [ 'foo1', 1 ], [ 'foo2', 2 ] ], h.subhash(/\Afoo\d/).to_a
      assert_equal [ [ 'foo2', 2 ] ], h.subhash('foo2').to_a
    end

    def test_subhash_bang
      h = { 'foo1' => 1, 'foo2' => 2, 'bar666' => 666 }
      h.subhash!('foo2')
      assert_equal [ [ 'foo2', 2 ] ], h.to_a
    end

    def test_subhash_with_block
      h = { 'foo1' => 1, 'foo2' => 2, 'bar666' => 666 }
      assert h.subhash(/\Abaz/) { :foo }.empty?
      assert_equal [ [ 'foo1', 1 ], [ 'foo2', 2 ] ],
        h.subhash(/\Afoo(\d)/) { |_,_,m| Integer(m[1]) }.to_a
    end
  end

  class NullTest < Test::Unit::TestCase
    require 'spruz/xt/null'

    def test_null
      assert_equal NULL, NULL.foo
      assert_equal NULL, NULL.foo.bar
      assert_equal 'NULL', NULL.inspect
      assert_equal '', NULL.to_s
    end
  end

  class TimeDummyTest < Test::Unit::TestCase
    require 'spruz/xt/time_dummy'
    require 'time'

    def test_time_dummy
      time = Time.parse('2009-09-09 21:09:09')
      assert_not_equal time, Time.now
      Time.dummy = time
      assert_equal time, Time.now
      Time.dummy = nil
      assert_not_equal time, Time.now
    end
  end

  class BlankFullTest < Test::Unit::TestCase
    require 'spruz/xt/full'
    require 'spruz/xt/symbol_to_proc'
    require 'set'

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

  class BlankFullTest < Test::Unit::TestCase
    require 'spruz/xt/deep_dup'

    def test_deep_dup
      a = [1,2,3]
      assert_equal    a, a.deep_dup
      assert_not_same a, a.deep_dup
    end

    def test_deep_dup_proc
      f = lambda { |x| 2 * x }
      g = f.deep_dup
      assert_equal f[3], g[3]
      assert_equal f, g
      assert_same  f, g
    end
  end

  class BijectionTest < Test::Unit::TestCase
    def test_bijection
      assert_equal [ [ 1, 2 ], [ 3, 4 ] ], Spruz::Bijection[ 1, 2, 3, 4 ].to_a
      assert_raise(ArgumentError) do
        Spruz::Bijection[1,2,3]
      end
      assert_raise(ArgumentError) do
        Spruz::Bijection[1,2,3,2]
      end
      assert_raise(ArgumentError) do
        Spruz::Bijection[1,2,1,3]
      end
    end
  end

  class TryTest < Test::Unit::TestCase
    require 'spruz/xt/attempt'

    def test_attempt_block_condition
      assert attempt(:attempts => 1, :exception_class => nil) { |c| c == 1 }
      assert attempt(:attempts => 3, :exception_class => nil) { |c| c == 1 }
      assert_equal false, attempt(:attempts => 3, :exception_class => nil) { |c| c == 4 }
      assert_nil attempt(:attempts => 0, :exception_class => nil) { |c| c == 4 }
      assert_raise(Exception) { attempt(:attempts => 3, :exception_class => nil) { raise Exception } }
    end

    class MyError < StandardError; end
    class MyException < Exception; end

    def test_attempt_default_exception
      assert attempt(1) { |c| c != 1 and raise MyError }
      assert attempt(3) { |c| c != 1 and raise MyError }
      assert_equal false, attempt(3) { |c| c != 4 and raise MyError }
      assert_nil attempt(0) { |c| c != 4 and raise MyError }
      assert_raise(Exception) { attempt(3) { raise Exception } }
    end

    def test_attempt_exception
      assert attempt(:attempts => 1, :exception_class => MyException) { |c| c != 1 and raise MyException }
      assert attempt(:attempts => 3, :exception_class => MyException) { |c| c != 1 and raise MyException }
      assert_equal false, attempt(:attempts => 3, :exception_class => MyException) { |c| c != 4 and raise MyException }
      assert_nil attempt(:attempts => 0, :exception_class => MyException) { |c| c != 4 and raise MyException }
      assert_raise(Exception) { attempt(:attempts => 3, :exception_class => MyException) { raise Exception } }
    end
  end

  class RangePlustTest < Test::Unit::TestCase
    require 'spruz/xt/range_plus'

    def test_range_plus
      assert_equal [], (0...0) + (0...0)
      assert_equal [ 0 ], (0..0) + (0...0)
      assert_equal [ 0, 0 ], (0..0) + (0..0)
      assert_equal((1..5).to_a, (1...3) + (3..5))
    end
  end

  class NamedTest < Test::Unit::TestCase
    require 'spruz/xt/named'

    def test_named_simple
      a = [ 1, 2, 3 ]
      a.named(:plus1, :map) { |x| x + 1 }
      assert_equal [ 2, 3, 4 ], a.plus1
      Array.named(:odd, :select) { |x| x % 2 == 1 }
      assert_equal [ 3 ], a.plus1.odd
    end

    if RUBY_VERSION >= '1.9'
      def foo(x, y, &block)
        block.call x * y
      end

      def test_more_complex
        Object.named(:foo_with_block, :foo) do |z|
          z ** 2
        end
        assert_equal foo(2, 3) { |z| z ** 2 }, foo_with_block(2, 3)
        Object.named(:foo_23, :foo, 2, 3)
        assert_equal foo(2, 3) { |z| z ** 2 }, foo_23 { |z| z ** 2 }
        Object.named(:foo_2, :foo, 2)
        assert_equal foo(2, 3) { |z| z ** 2 }, foo_2(3) { |z| z ** 2 }
      end
    end
  end

  require 'spruz/xt/string'
  class StringCamelizeTest < Test::Unit::TestCase
    def test_camelize
      assert_equal 'FooBar', 'foo_bar'.camelize
      assert_equal 'FooBar', 'foo_bar'.camelize(:upper)
      assert_equal 'FooBar', 'foo_bar'.camelize(true)
      assert_equal 'fooBar', 'foo_bar'.camelize(:lower)
      assert_equal 'fooBar', 'foo_bar'.camelize(false)
      assert_equal 'FooBar', 'foo_bar'.camelcase
      assert_equal 'Foo::Bar', 'foo/bar'.camelize
      assert_equal 'Foo::Bar', 'foo/bar'.camelize(:upper)
      assert_equal 'Foo::Bar', 'foo/bar'.camelize(true)
      assert_equal 'foo::Bar', 'foo/bar'.camelize(:lower)
      assert_equal 'foo::Bar', 'foo/bar'.camelize(false)
      assert_equal 'Foo::Bar', 'foo/bar'.camelcase
    end
  end

  class StringUnderscoreTest < Test::Unit::TestCase
    def test_underscore
      assert_equal 'foo_bar', 'FooBar'.underscore
      assert_equal 'foo/bar', 'Foo::Bar'.underscore
    end
  end

  class StringVersionTest < Test::Unit::TestCase
    def test_comparison
      assert_operator '1.2'.version, :<, '1.3'.version
      assert_operator '1.3'.version, :>, '1.2'.version
      assert_operator '1.2'.version, :<=, '1.2'.version
      assert_operator '1.2'.version, :>=, '1.2'.version
      assert_operator '1.2'.version, :==, '1.2'.version
    end

    def test_change
      s = '1.2'
      s.version.revision = 1
      assert_equal '1.2.0.1', s
      s.version.revision += 1
      assert_equal '1.2.0.2', s
      s.version.succ!
      assert_equal '1.2.0.3', s
      s.version.pred!
      assert_equal '1.2.0.2', s
      assert_raise(ArgumentError) { s.version.build -= 1 }
      s.version.major = 2
      assert_equal '2.2.0.2', s
      s.version.minor = 1
      assert_equal '2.1.0.2', s
    end
  end
end
