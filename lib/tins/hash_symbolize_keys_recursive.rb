require 'tins/thread_local'

module Tins
  # This module provides recursive symbolization of hash keys. It handles
  # nested structures including hashes and arrays, with special handling for
  # circular references to prevent infinite recursion.
  #
  # @example Basic usage
  #   hash = { "name" => "John", "address" => { "street" => "123 Main St" } }
  #   hash.symbolize_keys_recursive
  #   # => { name: "John", address: { street: "123 Main St" } }
  #
  # @example Handling circular references
  #   hash = { "name" => "John" }
  #   hash["self"] = hash  # Circular reference
  #   hash.symbolize_keys_recursive(circular: "[Circular Reference]")
  #   # => { name: "John", self: "[Circular Reference]" }
  module HashSymbolizeKeysRecursive
    extend Tins::ThreadLocal

    # Thread-local storage for tracking visited objects to handle circular
    # references
    thread_local :seen

    # Recursively converts all string keys in a hash (and nested hashes/arrays)
    # to symbols. This method does not modify the original hash.
    #
    # @param circular [Object] The value to use when encountering circular references.
    #   Defaults to nil, which means circular references will be ignored.
    # @return [Hash, Array, Object] A new hash/array with symbolized keys
    #
    # @example Basic usage
    #   { "name" => "John", "age" => 30 }.symbolize_keys_recursive
    #   # => { name: "John", age: 30 }
    #
    # @example Nested structures
    #   {
    #     "user" => {
    #       "name" => "John",
    #       "hobbies" => ["reading", "swimming"]
    #     }
    #   }.symbolize_keys_recursive
    #   # => { user: { name: "John", hobbies: ["reading", "swimming"] } }
    #
    # @example Circular reference handling
    #   hash = { "name" => "John" }
    #   hash["self"] = hash
    #   hash.symbolize_keys_recursive(circular: "[Circular]")
    #   # => { name: "John", self: "[Circular]" }
    def symbolize_keys_recursive(circular: nil)
      self.seen = {}
      _transform_keys_recursive(self, circular: circular, transform: :to_sym)
    ensure
      self.seen = nil
    end

    # Converts all keys in the hash (and nested hashes) to strings.
    #
    # @param circular [Object] The value to return for circular references.
    # @return [Hash] A new hash with all keys converted to strings.
    #
    # @example
    #   hash = { name: "John", address: { city: "NYC" } }
    #   hash.stringify_keys_recursive
    #   # => { "name" => "John", "address" => { "city" => "NYC" } }
    def stringify_keys_recursive(circular: nil)
      self.seen = {}
      _transform_keys_recursive(self, circular: circular, transform: :to_s)
    ensure
      self.seen = nil
    end

    # Recursively converts all string keys in a hash (and nested hashes/arrays)
    # to symbols. This method modifies the original hash in place.
    #
    # @param circular [Object] The value to use when encountering circular references.
    #   Defaults to nil, which means circular references will be ignored.
    # @return [Hash, Array, Object] The same hash/array with symbolized keys
    #
    # @example Basic usage
    #   hash = { "name" => "John", "age" => 30 }
    #   hash.symbolize_keys_recursive!
    #   # => { name: "John", age: 30 }
    #   # hash is now modified in place
    def symbolize_keys_recursive!(circular: nil)
      replace symbolize_keys_recursive(circular: circular)
    end

    # Converts all keys in the hash (and nested hashes) to strings in place.
    #
    # @param circular [Object] The value to return for circular references.
    # @return [Hash] The same hash with all keys converted to strings.
    #
    # @example
    #   hash = { name: "John", address: { city: "NYC" } }
    #   hash.stringify_keys_recursive!
    #   # => { "name" => "John", "address" => { "city" => "NYC" } }
    def stringify_keys_recursive!(circular: nil)
      replace stringify_keys_recursive(circular: circular)
    end

    private

    # Performs the actual recursive transformation work
    #
    # @param object [Object] The object to process
    # @param circular [Object] The value to return for circular references
    # @param transform [Symbol] The transformation to apply to keys (`:to_sym` or `:to_s`).
    # @return [Object] The processed object with transformed keys
    def _transform_keys_recursive(object, circular: nil, transform:)
      case
      when seen[object.__id__]
        object = circular
      when object.respond_to?(:to_hash)
        object = object.to_hash
        seen[object.__id__] = true
        new_object = object.class.new
        seen[new_object.__id__] = true
        object.each do |k, v|
          new_object[k.to_s.__send__(transform)] =
            _transform_keys_recursive(v, circular: circular, transform:)
        end
        object = new_object
      when object.respond_to?(:to_ary)
        object = object.to_ary
        seen[object.__id__] = true
        new_object = object.class.new(object.size)
        seen[new_object.__id__] = true
        object.each_with_index do |v, i|
          new_object[i] = _transform_keys_recursive(v, circular: circular, transform:)
        end
        object = new_object
      end
      object
    end
  end
end
