require 'singleton'

module Tins

  SexySingleton = Singleton.dup

  module SexySingleton
    module SingletonClassMethods
    end
  end

  class << SexySingleton
    alias __old_singleton_included__ included

    def included(klass)
      __old_singleton_included__(klass)
      (class << klass; self; end).class_eval do
        def sexy_singleton_mutex_synchronize
          if @singleton__mutex__
            @singleton__mutex__.synchronize do
              yield
            end
          else
            begin
              old_critical, Thread.critical = Thread.critical, true
              result = yield
            ensure
              Thread.critical = old_critical
            end
            result
          end
        end

        if Object.method_defined?(:respond_to_missing?)
          def  respond_to_missing?(name, *args)
            sexy_singleton_mutex_synchronize do
              instance.respond_to?(name) || super
            end
          end
        else
          def respond_to?(name, *args)
            sexy_singleton_mutex_synchronize do
              instance.respond_to?(name) || super
            end
          end
        end

        def method_missing(name, *args, &block)
          sexy_singleton_mutex_synchronize do
            if instance.respond_to?(name)
              instance.__send__(name, *args, &block)
            else
              super
            end
          end
        end
      end
      super
    end
  end
end
