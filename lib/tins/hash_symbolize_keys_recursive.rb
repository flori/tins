require 'tins/deep_transform'

module Tins
  # This module provides deep symbolization of hash keys. It handles
  # nested structures including hashes and arrays, utilizing an iterative
  # engine to prevent stack overflows and handle circular references.
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
    include Tins::DeepTransform

    # Deeply converts all string keys in a hash (and nested hashes/arrays)
    # to symbols using an iterative approach to avoid SystemStackError.
    # This method does not modify the original hash.
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
      deep_transform(key: -> x { x.to_sym }, circular: circular)
    end

    # Deeply converts all keys in the hash (and nested hashes) to strings,
    # using an iterative approach to avoid SystemStackError.
    #
    # @param circular [Object] The value to return for circular references.
    # @return [Hash] A new hash with all keys converted to strings.
    #
    # @example
    #   hash = { name: "John", address: { city: "NYC" } }
    #   hash.stringify_keys_recursive
    #   # => { "name" => "John", "address" => { "city" => "NYC" } }
    def stringify_keys_recursive(circular: nil)
      deep_transform(key: -> x { x.to_s }, circular: circular)
    end

    # Deeply converts all string keys in a hash (and nested hashes/arrays)
    # to symbols using an iterative approach. This method modifies the
    # original hash in place.
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

    # Deeply converts all keys in the hash (and nested hashes) to strings
    # in place, using an iterative approach.
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
  end
end
