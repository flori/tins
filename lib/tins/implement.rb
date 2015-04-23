module Tins
  module Implement
    MESSAGES = {
      default:   'method %{method_name} not implemented in module %{module}',
      subclass:  'method %{method_name} has to be implemented in '\
        'subclasses of %{module}',
      submodule: 'method %{method_name} has to be implemented in '\
        'submodules of %{module}',
    }

    def implement(method_name, msg = :default)
      case msg
      when ::Symbol
        msg = MESSAGES.fetch(msg)
      when ::Hash
        return implement method_name, msg.fetch(:in)
      end
      begin
        msg = msg % { method_name: method_name, module: self }
      rescue KeyError
      end
      define_method(method_name) do |*|
        raise ::NotImplementedError, msg
      end
    end

    def implement_in_submodule(method_name)
      implement method_name,
        'method %{method_name} has to be implemented in submodules of'\
        ' %{module}'
    end
  end
end

