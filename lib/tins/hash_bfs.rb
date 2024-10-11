require 'tins/thread_local'

module Tins
  module HashBFS
    extend Tins::ThreadLocal

    thread_local :seen

    def bfs(include_nodes: false, &block)
      block or raise ArgumentError, 'require &block argument'
      self.seen = {}
      queue = []
      queue.push([ nil, self ])
      while (index, object = queue.shift)
        case
        when seen[object.__id__]
          next
        when Hash === object
          seen[object.__id__] = true
          object.each do |k, v|
            queue.push([ k, convert_to_hash_or_ary(v) ])
          end
          include_nodes or next
        when Array === object
          seen[object.__id__] = true
          object.each_with_index do |v, i|
            queue.push([ i, convert_to_hash_or_ary(v) ])
          end
          include_nodes or next
        end
        block.(index, object)
      end
      self
    ensure
      self.seen = nil
    end

    # Converts the given object into a hash or array if possible
    #
    # @param object [Object] The object to convert
    #
    # @return [Hash, Array, Object] The converted object or itself if not convertible
    def convert_to_hash_or_ary(object)
      case
      when object.respond_to?(:to_hash)
        object.to_hash
      when object.respond_to?(:to_ary)
        object.to_ary
      else
        object
      end
    end
  end
end

require 'tins/alias'
