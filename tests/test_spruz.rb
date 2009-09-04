#!/usr/bin/env ruby

require 'test/unit'
require 'spruz'

class TC_Minimize < Test::Unit::TestCase
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

class TC_PartialApplication < Test::Unit::TestCase
  class ::Proc
    include Spruz::PartialApplication
  end

  class ::Method
    include Spruz::PartialApplication
  end

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

class TC_Generator < Test::Unit::TestCase
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
    assert_equal [[1, "a", 97],
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

class TC_Round < Test::Unit::TestCase
  _ = Spruz::Round

  def test_standard
    assert_equal(1, 1.round)
    assert_equal(-1, -1.round)
    assert_equal(2, 1.5.round)
    assert_equal(-1, -1.4.round)
    assert_equal(-2, -1.5.round)
  end

  def test_inclusion
    assert_equal(10, 12.round(-1))
    assert_equal(-10, -12.round(-1))
    assert_raises(ArgumentError) { 12.round(-2) }
    assert_raises(ArgumentError) { -12.round(-2) }
    assert_equal(1.6, 1.55.round(1))
    assert_equal(2, 1.55.round(0))
    assert_equal(-1.5, -1.45.round(1))
    assert_equal(-1, -1.45.round(0))
    assert_equal(-1.6, -1.55.round(1))
    assert_equal(-2, -1.55.round(0))
  end
end

class TC_ModuleGroup < Test::Unit::TestCase
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

class TC_Uniq < Test::Unit::TestCase
  _ = Spruz::Uniq

  class Point < Struct.new :x, :y
  end

  def test_uniq
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

class TC_Shuffle < Test::Unit::TestCase
  class ::Array
    include Spruz::Shuffle
  end

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

class TC_Limited < Test::Unit::TestCase
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
    assert_equal 5, count.keys.uniq.size
  end
end

class TC_Memoize < Test::Unit::TestCase
  _ = Spruz::Memoize

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
