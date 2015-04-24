module Tins
  module StringVersion
    class Version
      include Comparable

      def initialize(string)
        string =~ /\A\d+(\.\d+)*\z/ or
          raise ArgumentError, "#{string.inspect} isn't a version number"
        @version = string.frozen? ? string.dup : string
      end

      def major
        self[0]
      end

      def major=(number)
        self[0] = number
      end

      def minor
        self[1]
      end

      def minor=(number)
        self[1] = number
      end

      def build
        self[2]
      end

      def build=(number)
        self[2] = number
      end

      def revision
        self[3]
      end

      def revision=(number)
        self[3] = number
      end

      def [](index)
        array[index]
      end

      def []=(index, value)
        value = value.to_i
        value >= 0 or raise ArgumentError,
          "version numbers can't contain negative numbers like #{value}"
        a = array
        @array = nil
        a[index] = value
        a.map!(&:to_i)
        @version.replace a * ?.
      end

      def succ
        dup.succ!
      end

      def succ!
        self[-1] += 1
        self
      end

      def pred
        dup.pred!
      end

      def pred!
        self[-1] -= 1
        self
      end

      def <=>(other)
        pairs = array.zip(other.array)
        pairs.map! { |a, b| [ a.to_i, b.to_i ] }
        a, b = pairs.transpose
        a <=> b
      end

      def ==(other)
        (self <=> other).zero?
      end

      def array
        @version.split(?.).map(&:to_i)
      end

      alias to_a array

      def to_s
        @version
      end

      alias inspect to_s

      def version
        self
      end
    end

    def version
      Version.new(self)
    end
  end
end

require 'tins/alias'
