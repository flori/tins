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
    def squeeze
      result = []
      prev   = A_THING_THAT_IS_NOT_A_THING

      each do |item|
        unless item == prev
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
    def squeeze!
      respond_to?(:replace) or raise 'cannot be squeezed in place!'
      squeezed = squeeze
      return if squeezed.count == count
      replace squeezed
    end
  end
end
