module Tins
  # DeepTransform provides a robust engine for traversing an object tree and
  # applying a transformation to each node iteratively, preventing stack
  # overflows.
  module DeepTransform
    # Transforms an object and its children using the provided lambdas. This
    # implementation uses an iterative bottom-up approach to avoid
    # SystemStackError.
    #
    # @param key [Proc, nil] An optional lambda/proc used to transform hash keys
    #   during reconstruction. Defaults to an identity transformation.
    # @param value [Proc, nil] An optional lambda/proc used to transform nodes
    #   (values) during reconstruction. Its behavior depends on its arity:
    #   - Arity 1: called with `(node)`
    #   - Arity 2: called with `(index_or_key, node)`
    #   - Arity 3: called with `(index_or_key, node, parent_container)`
    #   Defaults to an identity transformation.
    # @param circular [Object] value returned when a circular reference is detected
    # @return [Object] the fully transformed object tree
    # @raise [ArgumentError] if a block is provided (use `key:` and `value:` instead)
    def deep_transform(key: nil, value: nil, circular: nil)
      block_given? and raise ArgumentError, '&block not supported'
      _transform_iterative(self, key: key, value: value, circular: circular)
    end

    private

    # The core iterative engine used to traverse and transform object trees.
    #
    # This method implements a non-recursive, two-pass approach to avoid
    # `SystemStackError` on deeply nested structures:
    #
    # 1. **Discovery Pass**: Performs a pre-order traversal using an explicit stack
    #    to identify all reachable nodes in the tree, tracking them by their
    #    object ID (`__id__`) to handle shared references and circularities.
    # 2. **Reconstruction Pass**: Processes the discovered nodes in reverse
    #    order (bottom-up). This ensures that child nodes are transformed and
    #    stored in the results map before their parent nodes are processed.
    #
    # @param root [Object] The root object of the tree to be transformed.
    # @param key [Proc, nil] An optional lambda/proc used to transform hash keys
    #   during reconstruction. Defaults to an identity transformation.
    # @param value [Proc, nil] An optional lambda/proc used to transform nodes
    #   (values) during reconstruction. Its behavior depends on its arity:
    #   - Arity 1: called with `(node)`
    #   - Arity 2: called with `(index_or_key, node)`
    #   - Arity 3: called with `(index_or_key, node, parent_container)`
    #   Defaults to an identity transformation.
    # @param circular [Object] The value to assign when a circular reference is
    #   detected during the reconstruction phase.
    # @return [Object] The root of the newly reconstructed and transformed tree.
    #
    # @note This method relies on `to_hash` and `to_ary` to identify container
    #   nodes. Objects must implement these methods if they are to be treated
    #   as branch nodes in the tree.
    def _transform_iterative(root, key: nil, value: nil, circular:)
      key   ||= -> x { x }
      value ||= -> x { x }

      # Pass 1: Discovery (Pre-order traversal to find all nodes)
      nodes   = []
      stack   = [ [ nil, root, nil ] ]
      visited = {}

      while stack.any?
        idx, node, cont = stack.pop
        next if visited[node.__id__]

        visited[node.__id__] = true
        nodes << [ idx, node, cont ]

        # Unfold containers to find children for discovery
        if node.respond_to?(:to_hash)
          node.to_hash.each_pair { |k, v| stack << [ k, v, node ] }
        elsif node.respond_to?(:to_ary)
          node.to_ary.each_with_index { |v, i| stack << [ i, v, node ] }
        end
      end

      # Pass 2: Bottom-Up Reconstruction
      results = {}
      nodes.reverse_each do |idx, node, cont|
        transformed = case value.arity
                      when 1 then value.(node)
                      when 2 then value.(idx, node)
                      when 3 then value.(idx, node, cont)
                      else
                        raise ArgumentError, 'value lambda has to be arity in 1..3'
                      end

        if transformed.respond_to?(:to_hash)
          hash = transformed.to_hash
          new_hash = hash.dup.tap(&:clear)
          hash.each do |k, v|
            # Resolve child from results map or mark as circular
            new_hash[key.(k)] = results[v.__id__] ||
              (v.respond_to?(:to_hash) || v.respond_to?(:to_ary) ? circular : v)
          end
          transformed = new_hash
        elsif transformed.respond_to?(:to_ary)
          ary = transformed.to_ary
          transformed = ary.map do |v|
            results[v.__id__] ||
              (v.respond_to?(:to_hash) || v.respond_to?(:to_ary) ? circular : v)
          end
        end

        results[node.__id__] = transformed
      end

      results[root.__id__]
    end
  end
end
