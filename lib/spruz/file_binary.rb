require 'spruz/xt/hash_union'

module Spruz
  module FileBinary
    module Constants
      SEEK_SET = ::File::SEEK_SET

      ZERO   = "\x00"
      BINARY = "\x01-\x1f\x7f-\xff"

      if defined?(::Encoding)
        ZERO.force_encoding(Encoding::ASCII_8BIT)
        BINARY.force_encoding(Encoding::ASCII_8BIT)
      end
    end

    class << self
      attr_accessor :default_options
    end
    self.default_options = {
      :offset            => 0,
      :buffer_size       => 2 ** 13,
      :percentage_binary => 30.0,
      :percentage_zeros  => 0.0,
    }

    def binary?(options = {})
      options |= FileBinary.default_options
      old_pos = tell
      seek options[:offset], Constants::SEEK_SET
      data = read options[:buffer_size]
      !data or data.empty? and return nil
      data_size = data.size
      data.count(Constants::ZERO).to_f / data_size >
        options[:percentage_zeros] / 100.0 and return true
      data.count(Constants::BINARY).to_f / data_size >
        options[:percentage_binary] / 100.0
    ensure
      old_pos and seek old_pos, Constants::SEEK_SET
    end

    def ascii?(options = {})
      case binary?(options)
      when true   then false
      when false  then true
      end
    end

    def self.included(modul)
      modul.instance_eval do
        extend ClassMethods
      end
      super
    end

    module ClassMethods
      def binary?(name, options = {})
        open(name, 'rb') { |f| f.binary?(options) }
      end

      def ascii?(name, options = {})
        open(name, 'rb') { |f| f.ascii?(options) }
      end
    end
  end
end
