module Spruz
  class Bijection < Hash
    def initialize(inverted = Bijection.new(self))
      @inverted = inverted
    end

    def fill
      if empty?
        yield self
        freeze
      end
      self
    end

    def freeze
      r = super
      unless @inverted.frozen?
        @inverted.freeze
      end
      r
    end

    def []=(key, value)
      return if key?(key)
      super
      @inverted[value] = key
    end

    attr_reader :inverted
  end
end
