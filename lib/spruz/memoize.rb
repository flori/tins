module Spruz
  module Memoize
    class ::Module
      class << self
        # Returns the current memoize cache for all the stored objects and
        # method call results.
        def __memoize_cache__
          @__memoize_cache__ ||= {}
        end

        # Finalizer to delete the stored result for a garbage collected object.
        def __memoize_cache_delete__
          lambda do |id|
            $DEBUG and warn "Deleted method results for object id='#{id}'"
            __memoize_cache__.delete(id)
          end
        end
      end

      # Automatically memoize calls of the the methods +method_ids+. The
      # memoized results do NOT ONLY depend on the arguments, but ALSO on the
      # object the method is called on.
      def memoize_method(*method_ids)
        method_ids.each do |method_id|
          method_id = method_id.to_s.to_sym
          orig_method = instance_method(method_id)
          __send__(:define_method, method_id) do |*args|
            unless mc = ::Module.__memoize_cache__[__id__]
              mc = ::Module.__memoize_cache__[__id__] ||= {}
              ObjectSpace.define_finalizer(self, ::Module.__memoize_cache_delete__)
            end
            if mc.key?(method_id) and result = mc[method_id][args]
              result
            else
              (mc[method_id] ||= {})[args] = result = orig_method.bind(self).call(*args)
              $DEBUG and warn "#{self.class} cached method #{method_id}(#{args.inspect unless args.empty?}) = #{result.inspect} [#{__id__}]"
            end
            result
          end
        end
      end

      # Returns the current memoize cache for this Module.
      def __memoize_cache__
        @__memoize_cache__
      end

      # Automatically memoize calls of the functions +function_ids+. The
      # memoized result does ONLY depend on the arguments given to the
      # function.
      def memoize_function(*function_ids)
        mc = @__memoize_cache__ ||= {}
        function_ids.each do |method_id|
          method_id = method_id.to_s.to_sym
          orig_method = instance_method(method_id)
          __send__(:define_method, method_id) do |*args|
            if mc.key?(method_id) and result = mc[method_id][args]
              result
            else
              (mc[method_id] ||= {})[args] = result = orig_method.bind(self).call(*args)
              $DEBUG and warn "#{self.class} cached function #{method_id}(#{args.inspect unless args.empty?}) = #{result.inspect}"
            end
            result
          end
        end
      end

      # Clear cached values for all methods and functions.
      def memoize_cache_clear
        mc = @__memoize_cache__ and mc.clear
        mc = ::Module.__memoize_cache__ and mc.clear
        self
      end
    end
  end
end
