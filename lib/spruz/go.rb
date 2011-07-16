module Spruz
  module GO
    module_function

    # Parses the argument array _args_, according to the pattern _s_, to
    # retrieve the single character command line options from it. If _s_ is
    # 'xy:' an option '-x' without an option argument is searched, and an
    # option '-y foo' with an option argument ('foo').
    #
    # An option hash is returned with all found options set to true or the
    # found option argument.
    def go(s, args = ARGV)
      b,v = s.scan(/(.)(:?)/).inject([{},{}]) { |t,(o,a)|
        a = a == ':'
        t[a ? 1 : 0][o] = a ? nil : false
        t
      }
      while a = args.shift
        a !~ /\A-(.+)/ and args.unshift a and break
        p = $1
        until p == ''
          o = p.slice!(0, 1)
          if v.key?(o)
            if p == '' then
              v[o] = args.shift or break 1
            else
              v[0] = p
            end
            break
          elsif b.key?(o)
            b[o] = true
          else
            args.unshift a
            break 1
          end
        end and break
      end
      b.merge(v)
    end
  end
end
