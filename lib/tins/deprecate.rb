module Tins
  module Deprecate
    def deprecate(method:, new_method:, msg: nil)
      msg ||= "[DEPRECATION] `%{method}` is deprecated. Please use `%{new_method}` instead."
      msg = msg % { method: method, new_method: new_method }
      m = Module.new do
        define_method(method) do |*a, **kw, &b|
          warn msg
          super(*a, **kw, &b)
        end
      end
      prepend m
    end
  end
end
