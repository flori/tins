require 'test_helper'
require 'tins/xt/deep_transform'

module Tins
  class DeepTransformTest < Test::Unit::TestCase
    class HashLike
      attr_reader :name, :children
      def initialize(name, children = [])
        @name = name
        @children = children
      end

      def to_hash
        { name: @name, children: @children }
      end
    end

    def test_basic_transform
      # Simple identity transform on a flat hash
      h = { a: 1, b: 2 }
      result = h.deep_transform(value: -> node { node })
      assert_equal h, result
    end

    def test_identity_behavior
      # Test calling without any blocks - should act as a deep copy identity
      # transform
      h = { a: 1, b: { c: 2 }, d: [3, { e: 4 }] }
      result = h.deep_transform
      assert_equal h, result
      refute_same h, result # Ensure it's a new object (deep copy)
    end

    def test_value_transformation
      # Transform all numbers to strings
      h = { a: 1, b: [2, 3] }
      result = h.deep_transform(value: -> node {
        node.is_a?(Integer) ? node.to_s : node
      })
      assert_equal({ a: '1', b: ['2', '3'] }, result)
    end

    def test_key_transformation
      # Transform all keys to uppercase strings
      h = { name: 'John', details: { age: 30, city: 'Berlin' } }
      result = h.deep_transform(
        key:   -> k { k.to_s.upcase },
        value: -> node { node }
      )

      expected = {
        'NAME' => 'John',
        'DETAILS' => { 'AGE' => 30, 'CITY' => 'Berlin' }
      }
      assert_equal expected, result
    end

    def test_recursive_object_flattening
      # Objects unfold into hashes, which contain more objects.
      child = HashLike.new('Child')
      parent = HashLike.new('Parent', [child])
      root = { root_node: parent }

      result = root.deep_transform(
        value: -> node { node.respond_to?(:to_hash) ? node.to_hash : node }
      )

      expected = {
        root_node: {
          name: 'Parent',
          children: [ { name: 'Child', children: [] } ]
        }
      }
      assert_equal expected, result
    end

    def test_circular_reference_detection
      # Create a tight loop: A -> B -> A
      a = { name: 'A' }
      b = { name: 'B', parent: a }
      a[:child] = b

      placeholder = "🔄 LOOP"
      result = a.deep_transform(circular: placeholder, value: -> node { node })

      # Parent should be OK, Child's reference to Parent should be the placeholder
      assert_equal 'A', result[:name]
      assert_equal 'B', result[:child][:name]
      assert_equal placeholder, result[:child][:parent]
    end

    def test_deeply_nested_structure
      # Create a chain of 100 nested objects to ensure no stack overflow
      current = { val: 'leaf' }
      100.times do |i|
        current = { level: i, child: current }
      end

      result = current.deep_transform(value: -> node { node })
      # Just verify the depth is preserved without crashing
      depth = 0
      temp = result
      while temp.is_a?(Hash) && temp[:child]
        temp = temp[:child]
        depth += 1
      end
      assert_equal 100, depth
    end

    def test_mixed_containers
      # Test a mix of arrays and hashes
      h = {
        list: [ { item: 1 }, { item: 2 } ],
        meta: { tags: ['a', 'b'] }
      }
      result = h.deep_transform(value: -> node { node })
      assert_equal h, result
    end

    def test_empty_containers
      assert_equal({}, {}.deep_transform(value: -> node { node }))
    end

    def test_with_nil_values
      h = { a: nil, b: [nil, 1] }
      result = h.deep_transform(value: -> node { node })
      assert_equal({ a: nil, b: [nil, 1] }, result)
    end

    def test_arity_2_transformation
      # Transform values only if the key starts with 'a'
      h = { a_name: 'john', b_name: 'doe' }
      result = h.deep_transform(value: -> k, v {
        k.to_s.start_with?('a') ? v.upcase : v
      })
      assert_equal({ a_name: 'JOHN', b_name: 'doe' }, result)
    end

    def test_arity_3_transformation
      # Sliding window sum using parent context
      input = (1..5).to_a # [1, 2, 3, 4, 5]
      result = input.deep_transform(value: -> i, x, c {
        Integer === x ? (i + 1) * x : x
      })
      assert_equal [ 1, 4, 9, 16, 25 ], result # 🤔 I've seen this before
    end

    def test_invalid_zero_arity
      h = { a: 1 }
      assert_raise(ArgumentError) do
        h.deep_transform(value: -> { :nix })
      end
    end

    def test_invalid_arity
      h = { a: 1 }
      assert_raise(ArgumentError) do
        h.deep_transform(value: -> k, v, c, extra { v })
      end
    end
  end
end
