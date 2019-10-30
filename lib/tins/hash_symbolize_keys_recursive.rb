require 'tins/thread_local'

module Tins
  module HashSymbolizeKeysRecursive
    extend Tins::ThreadLocal

    thread_local :seen

    def symbolize_keys_recursive(circular: nil)
      self.seen = {}
      _symbolize_keys_recursive(self, circular: circular)
    ensure
      self.seen = nil
    end

    def symbolize_keys_recursive!(circular: nil)
      replace symbolize_keys_recursive(circular: circular)
    end

    private

    def _symbolize_keys_recursive(object, circular: nil)
      case
      when seen[object.__id__]
        circular != nil and object = circular
      when Hash === object
        seen[object.__id__] = true
        result = {}
        object.each do |k, v|
          result[k.to_s.to_sym] = _symbolize_keys_recursive(v, circular: circular)
        end
        object.replace result
      when Array === object
        seen[object.__id__] = true
        object.map! do |v|
          _symbolize_keys_recursive(v, circular: circular)
        end
      end
      object
    end
  end
end

require 'tins/alias'
