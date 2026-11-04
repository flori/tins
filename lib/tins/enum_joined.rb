module Tins
  # Adds +joined+ to any +Enumerable+, providing human-friendly
  # sentence-style joining with configurable connectors, similar
  # to Rails' +Array#to_sentence+.
  #
  # @example Polite usage (include into your own class):
  #   require 'tins/enum_joined'
  #
  #   class MyList
  #     include Enumerable
  #     include Tins::EnumJoined
  #
  #     def each
  #       %w[foo bar baz].each { |x| yield x }
  #     end
  #   end
  #
  #   MyList.new.joined  # => "foo, bar, and baz"
  #
  # @example Rude usage (mixin into ::Enumerable globally):
  #   require 'tins/xt/enum_joined'
  #
  #   [1, 2, 3].joined       # => "1, 2, and 3"
  #   Set['a', 'b', 'c'].joined  # => "a, b, and c"
  module EnumJoined
    # Join all elements into a human-readable sentence.
    #
    # Uses three connectors, mirroring Rails' +Array#to_sentence+:
    #
    # | elements | connectors used                       |
    # |----------|---------------------------------------|
    # | 0        | (none) — returns `""`                 |
    # | 1        | (none) — returns the element          |
    # | 2        | +two_words_connector+                 |
    # | 3+       | +words_connector+ + +last_word_connector+ |
    #
    # @param [String] words_connector
    #   Separator between all items except the last two.
    #   Default: `', '`.
    # @param [String] two_words_connector
    #   Separator between the only two items.
    #   Default: `' and '`.
    # @param [String] last_word_connector
    #   Separator before the last item (3+ items only).
    #   Default: `', and '` (Oxford comma).
    #
    # @return [String] the joined sentence
    #
    # @example Default connectors
    #   [1, 2].joined        # => "1 and 2"
    #   [1, 2, 3].joined     # => "1, 2, and 3"
    #
    # @example Custom connectors
    #   [1, 2, 3].joined(words_connector: ' / ',
    #                     last_word_connector: ' / ')
    #   # => "1 / 2 / 3"
    def joined(words_connector: ', ',
               two_words_connector: ' and ',
               last_word_connector: ', and ')
      items = map(&:to_s)
      case items.size
      when 0 then ''
      when 1 then items.first
      when 2 then items.first + two_words_connector + items.last
      else
        head, tail = items[0..-2], items.last
        head.join(words_connector) + last_word_connector + tail
      end
    end
  end
end
