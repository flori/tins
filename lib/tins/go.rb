module Tins
  # A command-line option parsing library that provides a flexible way to
  # parse single-character options with optional arguments. It supports
  # multiple values for the same flag and provides a clean API for handling
  # command-line interfaces.
  #
  # @example Basic usage
  #   # Parse options with pattern 'xy:z'
  #   options = Tins::GO.go('xy:z', ARGV, defaults: { x: true, y: 'default' })
  #   # Handles: -x -y value -z
  #
  # @example Multiple values for same option
  #   # Handle: -f foo -f bar -f baz
  #   options = Tins::GO.go('f:', ARGV)
  #   # options['f'] will contain an EnumerableExtension collection with all
  #   values, see `option['f'].to_a`
  module GO
    # An extension module that provides Enumerable behavior for collecting
    # multiple values associated with the same command-line option.
    #
    # This extension enables command-line flags like `-f foo -f bar` to be
    # collected into a single collection that can be queried via #to_a or #each.
    module EnumerableExtension
      # Adds an element to the collection.
      #
      # This method allows for chaining operations and collects multiple
      # values for the same command-line option.
      #
      # @param argument [Object] The element to add to the collection
      # @return [self] Returns self to enable method chaining
      def push(argument)
        @arguments ||= []
        @arguments.push argument
        self
      end

      # Alias for {#push}
      #
      # Enables intuitive syntax for adding elements: `collection << item`
      #
      # @see #push
      alias << push

      # Iterates over each element in the collection.
      #
      # Implements the Enumerable interface, allowing the use of all Enumerable
      # methods like map, select, find, etc.
      #
      # @yield [element] Yields each element in the collection
      # @yieldparam element [Object] Each element in the collection
      # @return [self] Returns self to enable method chaining
      def each(&block)
        @arguments.each(&block)
        self
      end

      # Includes the Enumerable module to provide rich iteration capabilities.
      #
      # This enables the use of methods like map, select, find, etc.
      include Enumerable
    end

    module_function

    # Parses the argument array _args_, according to the pattern _s_, to
    # retrieve the single character command line options from it. If _s_ is
    # 'xy:' an option '-x' without an option argument is searched, and an
    # option '-y foo' with an option argument ('foo'). To disable the '-x'
    # option, pass '~x'.
    #
    # The _defaults_ argument specifies default values for the options.
    #
    # An option hash is returned with all found options set to a truthy value
    # representing the number of times they were encountered, or `false` if not
    # present. When a default value is specified and the flag is not present,
    # the default value is used instead.
    #
    # @param s [String] Option pattern string where each character represents
    #   an option, and ':' indicates the option requires an argument
    # @param args [Array<String>] Array of arguments to parse (defaults to ARGV)
    # @param defaults [Hash{String => Object}] Default values for options
    # @return [Hash{String => Object}] Hash mapping option names to their values
    #
    # @example Basic usage
    #   # Parse options with pattern 'xy:z'
    #   options = Tins::GO.go('xy:z', ARGV, defaults: { x: true, y: 'default' })
    #   # Handles: -x -y value -z
    #
    # @example Multiple values for same option
    #   # Handle: -f foo -f bar -f baz
    #   options = Tins::GO.go('f:', ARGV)
    #   # options['f'] will contain an EnumerableExtension collection with
    #   # all values, see options['f'].to_a
    #
    # @example Boolean flag counting
    #   # Handle: -x -x -x
    #   options = Tins::GO.go('x', ARGV)
    #   # options['x'] will be 3 (truthy numeric value)
    #
    # @example Boolean flag not present
    #   # Handle: no -x flag
    #   options = Tins::GO.go('x', ARGV)
    #   # options['x'] will be false
    #
    # @example Disabling options with default values
    #   # Handle: ~x (disables -x option) when x has a default value
    #   options = Tins::GO.go('x', ARGV, defaults: { x: true })
    #   # options['x'] will be false if no ~x flag is present
    def go(s, args = ARGV, defaults: {})
      d = defaults || {}
      b, v = s.scan(/(.)(:?)/).inject([ {}, {} ]) { |t, (o, a)|
        a = a == ?:
        t[a ? 1 : 0][o] = a ? nil : false
        t
      }
      b.each_key do |k|
        d.key?(k) or next
        if [ 0, false, nil ].include?(d[k])
          b[k] = false
        elsif d[k].respond_to?(:to_int)
          b[k] = d[k].to_int
        else
          b[k] = 1
        end
      end
      v.each_key do |k|
        d.key?(k) or next
        if [ 0, false, nil ].include?(d[k])
          v[k] = nil
        else
          v[k] = d[k].to_s
        end
      end
      r = []
      while a = args.shift
        /\A-(?<p>.+)/ =~ a or (r << a; next)
        until p == ''
          o = p.slice!(0, 1)
          if v.key?(o)
            if p.empty? && args.empty?
              r << a
              break 1
            elsif p == ''
              a = args.shift
            else
              a = p
            end
            if v[o].nil? || !(EnumerableExtension === v[o])
              a = a.dup
              a.extend EnumerableExtension
              a << a
              v[o] = a
            else
              v[o] << a
            end
            break
          elsif b.key?(o)
            if b[o]
              b[o] += 1
            else
              b[o] = 1
            end
          else
            r << a
          end
        end && break
      end
      r.reject! { |a| (b[p] = false) || true if /\A~(?<p>.)/ =~ a  }
      args.replace r
      b.merge(v)
    end
  end
end
