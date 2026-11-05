# frozen_string_literal: false

require 'tins/enum_joined'

module Tins
  # A class to represent durations with support for formatting and parsing time
  # intervals.
  class Duration
    include Comparable

    # Raised when a duration string cannot be parsed by any of the
    # provided templates.
    #
    # @see .parse
    class ParserError < ArgumentError
    end

    # Built-in label styles for {#to_human}. Keys are the unit format
    # directives (see {#format}); values are the literal strings appended
    # directly after each unit's numeric value.
    #
    # +:abbrev+ uses single-letter suffixes (the default); +:words+ uses
    # spelled-out units. A caller may instead pass their own +Hash+ with the
    # same keys to {#to_human} to override either built-in, e.g. for another
    # language.
    #
    # @see #to_human
    HUMAN_STYLES = {
      abbrev: { '%d' => 'd', '%h' => 'h', '%m' => 'm', '%s' => 's' }.freeze,
      words:  {
                '%d' => ' days',   '%h' => ' hours',
                '%m' => ' minutes', '%s' => ' seconds'
              }.freeze
    }.freeze

    class << self
      # Parses a duration string against one or more templates,
      # returning the total number of seconds.
      #
      # Templates are tried in order; the first one that matches wins.
      # If no template matches, a {ParserError} is raised.
      #
      # @param [String] string The duration string to parse.
      # @param [String, Array<String>, nil] template A single template
      #   string, an array of template strings tried in order, or +nil+
      #   (the built-in default `'%S%d+%h:%m:%s.%f'`).
      #
      # @return [Integer, Float] The number of (fractional) seconds.
      #
      # @raise [ParserError] If no template matches the string.
      #
      # @see #from_string
      # @see #format
      #
      # @example Default template
      #   Tins::Duration.parse('6+05:04:03')       # => 536643
      #   Tins::Duration.parse('6+05:04:03.21')    # => 536643.21
      #
      # @example Parsing negative durations
      #   Tins::Duration.parse('-6+05:04:03')      # => -536643
      #
      # @example Custom template
      #   Tins::Duration.parse('05:04:03.21', template: '%h:%m:%s.%f')
      #   # => 18243.21
      #
      # @example Multiple templates (first match wins)
      #   Tins::Duration.parse('1m 30s',
      #     template: [ '%m minutes %s seconds', '%S%d+%h:%m:%s.%f' ]
      #   )
      def parse(string, template: nil)
        templates = Array(template).dup
        templates.empty? and templates << '%S%d+%h:%m:%s.%f'
        templates.each do |template|
          result = parse_template(string, template:) and return result
        rescue ParserError
        end
        raise ParserError, "#{string.inspect} did not match any of the " \
          "templates in #{template.inspect}"
      end

      # Parses a duration string against a single template.
      #
      # Supported directives:
      # - `%S` - Sign indicator (optional negative sign)
      # - `%d` - Days component (integer)
      # - `%h` - Hours component (integer)
      # - `%m` - Minutes component (integer)
      # - `%s` - Seconds component (integer)
      # - `%f` - Fractional seconds component (decimal)
      # - `%%` - Literal percent character
      #
      # The parser is greedy and consumes as much of the input string as
      # possible for each directive. If a directive expects a specific
      # format but doesn't find it, a {ParserError} is raised.
      def parse_template(string, template:)
        s, t  = string.to_s.dup, template.dup
        d, sd = 0, 1
        loop do
          t.sub!(/\A(%[Sdhmsf%]|.)/) { |directive|
            case directive
            when '%S' then s.sub!(/\A-?/)   { sd *= -1 if _1 == ?-; '' }
            when '%d' then s.sub!(/\A\d+/)  { d += 86_400 * _1.to_i; '' }
            when '%h' then s.sub!(/\A\d+/)  { d += 3_600 * _1.to_i; '' }
            when '%m' then s.sub!(/\A\d+/)  { d += 60 * _1.to_i; '' }
            when '%s' then s.sub!(/\A\d+/)  { d += _1.to_i; '' }
            when '%f' then s.sub!(/\A\d+/)  { d += Float(?. + _1); '' }
            when '%%' then
              if s[0] == ?%
                s[0] = ''
              else
                raise ParserError, "expected %s, got #{s.inspect}"
              end
            else
              if directive == s[0]
                s[0] = ''
              else
                raise ParserError, "expected #{t.inspect}, got #{s.inspect}"
              end
            end
            ''
          } or break
        end
        sd * d
      end
      private :parse_template

      # Creates a new {Duration} instance by parsing the given string
      # with {#parse}.
      #
      # @param [String] string The duration string to parse.
      # @param [String, nil] template for the duration format, see
      #   {#format}. Default: +nil+ (falls back to the built-in format).
      #
      # @return [Duration] A new {Duration} instance.
      #
      # @raise [Duration::ParserError] If the string doesn't match the
      #   expected template format.
      #
      # @see .parse
      #
      # @example Basic usage
      #   Tins::Duration.from_string('6+05:04:03.21')
      #   # => #<Tins::Duration: 6+05:04:03.210>
      #
      # @example Custom template
      #   Tins::Duration.from_string('05:04:03', template: '%h:%m:%s')
      #   # => #<Tins::Duration: 0+05:04:03.000>
      def from_string(string, template: nil)
        new(parse(string, template:))
      end
    end

    # Initializes a new Duration object with the specified number of seconds.
    #
    # @param seconds [ Integer, Float ] the total number of seconds to
    # represent
    def initialize(seconds)
      @negative         = seconds < 0
      seconds           = seconds.abs
      @original_seconds = seconds
      @days, @hours, @minutes, @seconds, @fractional_seconds =
        [ 86_400, 3600, 60, 1, 0 ].inject([ [], seconds ]) {|(r, s), d|
          if d > 0
            dd, rest = s.divmod(d)
            r << dd
            [ r, rest ]
          else
            r << s
          end
        }
    end

    # Returns the duration's magnitude in seconds as a floating-point
    # number.
    #
    # A duration represents the time span between two points; the span
    # itself is always non-negative. The sign is a direction qualifier,
    # tracked separately — see {#negative?}.
    #
    # @return [Float] The magnitude of the duration in seconds.
    #   Always non-negative.
    def to_f
      @original_seconds.to_f
    end

    # The <=> method compares this object with another object after converting
    # both to floats.
    #
    # @param other [Object] the object to compare with
    #
    # @return [Integer] -1 if this object is less than other, 0 if they are
    # equal, 1 if this object is greater than other
    def <=>(other)
      to_f <=> other.to_f
    end

    # Returns true if the duration is negative.
    #
    # @return [TrueClass, FalseClass] true if the duration represents a
    # negative time interval, false otherwise
    def negative?
      @negative
    end

    # Returns true if the duration includes days, false otherwise.
    #
    # @return [TrueClass, FalseClass] true if the duration has any days, false
    # otherwise
    def days?
      @days > 0
    end

    # Returns true if the duration has any hours component
    #
    # @return [TrueClass, FalseClass] true if hours are present, false
    # otherwise
    def hours?
      @hours > 0
    end

    # Returns true if the duration has minutes, false otherwise.
    #
    # @return [TrueClass, FalseClass] true if minutes are greater than 0, false otherwise
    def minutes?
      @minutes > 0
    end

    # Returns true if the duration has a positive seconds component.
    #
    # @return [TrueClass, FalseClass] true if seconds are greater than zero,
    # false otherwise
    def seconds?
      @seconds > 0
    end

    # Returns true if the duration includes fractional seconds.
    #
    # @return [TrueClass, FalseClass] true if fractional seconds are present,
    # false otherwise
    def fractional_seconds?
      @fractional_seconds > 0
    end

    # Returns a human-readable string representation of the duration.
    # pass +style: :words+ for spelled-out units
    # (e.g. `1 minutes and 30 seconds`), or pass your own +Hash+ keyed
    # by the unit format directives (`'%d'`, `'%h'`, `'%m'`, `'%s'`) to use
    # arbitrary wording or another language.
    #
    # Fractional seconds are truncated (not rounded).
    #
    # @param max [Integer] Maximum number of time units to include,
     #   starting from the largest. Default: +nil+ (all units).
    # @param words_connector [String] Separator between
    #   items (3+ only). Default: `', '`.
    # @param two_words_connector [String] Separator between
    #   exactly two items. Default: `' and '`.
    # @param last_word_connector [String] Separator before the
    #   last item (3+ only). Default: `', and '`.
    # @param style [Symbol, Hash] Built-in label style (+:abbrev+ or
    #   +:words+, see {HUMAN_STYLES}) or a custom +Hash+ mapping the unit
    #   format directives to label strings. A +Hash+ is merged onto the
    #   +:abbrev+ defaults, so omitting a key keeps the single-letter label.
    #   Default: +:abbrev+.
    #
    # @raise [ArgumentError] If +style+ is neither a +Symbol+ nor a +Hash+.
    #
    # @return [String] Human-readable duration string.
    #
    # @see Tins::EnumJoined#joined
    #
    # @example Basic usage (default +:abbrev+ style)
    #   Tins::Duration.new(90).to_human       # => "1m and 30s"
    #   Tins::Duration.new(3725).to_human     # => "1h and 2m"
    #   Tins::Duration.new(86_400).to_human   # => "1d"
    #   Tins::Duration.new(0).to_human        # => "0s"
    #
    # @example Spelled-out units
    #   Tins::Duration.new(90).to_human(style: :words)
    #   # => "1 minutes and 30 seconds"
    #
    # @example Custom labels (e.g. another language)
    #   Tins::Duration.new(90).to_human(
    #     style: { '%m' => ' Min.', '%s' => ' Sek.' }
    #   )
    #   # => "1 Min. and 30 Sek."
    #
    # @example Negative durations
    #   Tins::Duration.new(-90).to_human      # => "-1m and 30s"
    def to_human(max: nil, style: :abbrev,
                 words_connector: ', ',
                 two_words_connector: ' and ',
                 last_word_connector: ', and ')
      labels =
        case style
        when Hash   then HUMAN_STYLES[:abbrev].merge(style)
        when Symbol then HUMAN_STYLES.fetch(style)
        else raise ArgumentError,
          "style must be a Symbol or Hash, got #{style.class}"
        end
      parts = [
        [ @days, '%d' ], [ @hours, '%h' ],
        [ @minutes, '%m' ], [ @seconds, '%s' ]
      ].select { |v, _| v > 0 }
      parts << [ 0, '%s' ] if parts.empty?
      parts  = parts.first(max) if max
      items  = parts.map { |v, d| "#{v}#{labels[d]}" }
               .extend(EnumJoined)
      result = items.joined(
        words_connector:, two_words_connector:, last_word_connector:
      )
      @negative ? "-#{result}" : result
    end

    # Formats the duration according to the given template and precision.
    #
    # The template string supports the following directives:
    # - `%S` - Sign indicator (negative sign if duration is negative)
    # - `%d` - Days component
    # - `%H` - Hours component (unpadded)
    # - `%h` - Hours component (zero-padded to 2 digits)
    # - `%M` - Minutes component (unpadded)
    # - `%m` - Minutes component (zero-padded to 2 digits)
    # - `%u` - Seconds component (unpadded)
    # - `%s` - Seconds component (zero-padded to 2 digits)
    # - `%f` - Fractional seconds component (without the leading decimal point)
    # - `%D` - Smart format (automatically includes days, fractional seconds, and sign)
    # - `%%` - Literal percent character
    #
    # When using `%f`, the fractional part will be formatted according to the precision parameter.
    #
    # @param template [String] the format template to use for formatting
    #   Default: '%S%d+%h:%m:%s.%f'
    # @param precision [Integer] the precision to use for fractional seconds
    #   When nil, uses default formatting with 6 decimal places
    #
    # @return [String] the formatted duration string
    #
    # @example Basic formatting
    #   duration = Tins::Duration.new(93784.123)
    #   duration.format('%d+%h:%m:%s.%f') # => "1+02:03:04.123000"
    #
    # @example Smart format
    #   duration.format('%D') # => "1+02:03:04.123"
    #
    # @example Custom precision
    #   duration.format('%s.%f', precision: 2) # => "04.12"
    #
    # @example Unpadded components
    #   duration = Tins::Duration.new(93_784)
    #   duration.format('%d day(s), %H hours, %M minutes, and %u seconds')
    #   # => "1 day(s), 2 hours, 3 minutes, and 4 seconds"
    def format(template = '%S%d+%h:%m:%s.%f', precision: nil)
      result = template.gsub(/%[DdHhMmuSs%]/) { |directive|
        case directive
        when '%S' then ?- if negative?
        when '%d' then @days
        when '%H' then '%u' % @hours
        when '%h' then '%02u' % @hours
        when '%M' then '%u' % @minutes
        when '%m' then '%02u' % @minutes
        when '%u' then '%u' % @seconds
        when '%s' then '%02u' % @seconds
        when '%D' then format_smart
        when '%%' then '%'
        end
      }
      if result.include?('%f')
        if precision
          fractional_seconds = "%.#{precision}f" % @fractional_seconds
        else
          fractional_seconds = '%f' % @fractional_seconds
        end
        result.gsub!('%f', fractional_seconds[2..-1])
      end
      result
    end

    # The to_s method returns a string representation of the duration by
        # formatting it using the smart format method
    #
    # @return [String] the formatted duration string
    def to_s
      format_smart
    end

    private

    # The format_smart method provides intelligent formatting based on the
    # duration's components. It automatically determines which components are
    # present and formats them accordingly, making it ideal for human-readable
    # output where you want to avoid showing zero values.
    #
    # The smart format follows these rules:
    # - If days are present, includes the day component (e.g., "1+02:03:04") -
    # If fractional seconds are present, includes them with 3 decimal places
    # (e.g., ".123")
    # - If the duration is negative, includes the sign prefix
    #
    # This method is used internally by #to_s and can also be called directly
    # for smart formatting using the %D directive.
    #
    # @return [String] a formatted duration string using intelligent component
    # inclusion
    def format_smart
      template  = '%h:%m:%s'
      precision = nil
      if days?
        template.prepend '%d+'
      end
      if fractional_seconds?
        template << '.%f'
        precision = 3
      end
      template.prepend '%S'
      format template, precision: precision
    end
  end
end
