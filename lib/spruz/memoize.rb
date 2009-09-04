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
          orig_method = instance_method(method_id)
          __send__(:define_method, method_id) do |*args|
            unless mc = ::Module.__memoize_cache__[__id__]
              mc = ::Module.__memoize_cache__[__id__] ||= {}
              ObjectSpace.define_finalizer(self, ::Module.__memoize_cache_delete__)
            end
            if mc.key?(args)
              result = mc[args]
            else
              result = mc[args] = orig_method.bind(self).call(*args)
              if $DEBUG
                warn "#{self.class} cached method #{method_id}(#{args.inspect unless args.empty?}) = #{result.inspect} [#{__id__}]"
              end
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
          orig_method = instance_method(method_id)
          __send__(:define_method, method_id) do |*args|
            if mc.key?(args)
              result = mc[args]
            else
              result = mc[args] = orig_method.bind(self).call(*args)
              if $DEBUG
                warn "#{self.class} cached function #{method_id}(#{args.inspect unless args.empty?}) = #{result.inspect}"
              end
            end
            result
          end
        end
      end
    end
  end
end
