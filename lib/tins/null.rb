module Tins
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

    def nil?
      true
    end

    module Kernel
      def Null(value = nil)
        value.nil? ? Tins::NULL : value
      end
    end
  end

  NULL = Class.new do
    include Tins::Null
  end.new.freeze
end

require 'tins/alias'
