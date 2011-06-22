module Spruz
  # Implementation of the null object pattern in Ruby.
  module Null
    def method_missing(*)
      self
    end

    def const_missing(*)
      self
    end

    def to_s
      ''
    end

    def inspect
      'NULL'
    end
  end

  NULL = Class.new do
    include Spruz::Null
  end.new
end
