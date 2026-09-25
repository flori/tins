module Tins
  module EnumSqueeze
    A_THING_THAT_IS_NOT_A_THING = Object.new.freeze

    private_constant :A_THING_THAT_IS_NOT_A_THING

    # Collapse consecutive duplicate elements, mirroring
    # +String#squeeze+.
    #
    # Two elements are considered duplicates when
    # +item == previous+ is true.
    #
    # Optionally restrict squeezing to elements matching one or
    # more selectors via case-equality (+===+), mirroring how
    # +String#squeeze+ uses character-class expressions.
    # Elements not matching any selector are never collapsed.
    #
    # @param [Array] sels
    #   Case-equality matchers (types, ranges, regexes, or any
    #   object responding to +===+) defining which elements are
    #   eligible for squeezing.
    # @param [Proc, nil] block
    #   A predicate; when it returns false for an element, that
    #   element is never collapsed. Mutually exclusive with +sels+.
    #
    # @return [Array] a new array with consecutive duplicates removed
    #
    # @example Basic usage:
    #   [1, 1, 2, 2, 3, 1].squeeze  # => [1, 2, 3, 1]
    #
    # @example Only consecutive duplicates are collapsed:
    #   [1, 2, 1, 2, 1].squeeze     # => [1, 2, 1, 2, 1]
    #
    # @example Mirrors String#squeeze semantics:
    #   "aabbcc".squeeze            # => "abc"
    #
    # @example Squeeze only elements in a range:
    #   [1, 3, 2, 2, 4, 6, 3, 3, 7].squeeze(2..3)
    #   # => [1, 3, 2, 4, 6, 3, 7]
    #
    # @example Squeeze only elements of a given type:
    #   [[1], '1', [1], [1], '1', '1', [1]].squeeze(String)
    #   # => [[1], "1", [1], [1], "1", [1]]
    #
    # @example Squeeze using a predicate block:
    #   [1, 3, 2, 2, 4, 6, 3, 3, 7].squeeze(&:even?)
    #   # => [1, 3, 2, 4, 6, 3, 3, 7]
    #
    # @example Enumerable/String invariance:
    #   str = 'fooaabaaz'
    #   str.squeeze(?a) == str.split('').squeeze(?a).join
    #   # => true
    def squeeze(*sels, &block)
      !sels.empty? && block and raise ArgumentError,
        'you cannot pass both *sels and &block'

      unless block
        if sels.empty?
          block = -> x { true }
        else
          block = -> x { sels.any? { _1 === x } }
        end
      end

      result = []
      prev   = A_THING_THAT_IS_NOT_A_THING

      each do |item|
        if item != prev || !block.(item)
          result << item
          prev = item
        end
      end

      result
    end

    # Collapse consecutive duplicate elements in place.
    #
    # Destructive counterpart to +squeeze+: the receiver is modified
    # via +replace+; no new object is allocated.
    #
    # @param [Array] sels
    #   Case-equality matchers (see +squeeze+).
    # @param [Proc, nil] block
    #   A predicate (see +squeeze+).
    #
    # @return [self] if one or more consecutive duplicates were removed
    # @return [nil]  if the receiver was already free of consecutive
    #   duplicates
    # @raise [RuntimeError] if the receiver does not respond to
    #   +replace+ and therefore cannot be squeezed in place
    # @see squeeze
    #
    # @example Squeezing an array with consecutive duplicates:
    #   a = [1, 1, 2, 2, 3, 1]
    #   a.squeeze!  # => self
    #   a           # => [1, 2, 3, 1]
    #
    # @example No consecutive duplicates — returns nil:
    #   b = [1, 2, 3]
    #   b.squeeze!  # => nil
    #   b           # => [1, 2, 3]
    #
    # @example Squeezing with a selector:
    #   a = [1, 3, 2, 2, 4, 6, 3, 3, 7]
    #   a.squeeze!(2..3)
    #   a           # => [1, 3, 2, 4, 6, 3, 7]
    def squeeze!(*sels, &block)
      respond_to?(:replace) or raise 'cannot be squeezed in place!'
      squeezed = squeeze(*sels, &block)
      return if squeezed.count == count
      replace squeezed
    end
  end
end
