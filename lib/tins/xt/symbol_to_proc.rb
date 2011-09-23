module Tins
  unless ::Symbol.method_defined?(:to_proc)
    class ::Symbol
      include ToProc
    end
  end
end
