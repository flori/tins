module Tins
  module DateTimeDummy
    def self.included(modul)
      class << modul
        alias really_now now

        remove_method :now rescue nil

        include ClassMethods
      end
      super
    end

    module ClassMethods
      attr_writer :dummy

      def dummy(value = nil)
        if value.nil?
          @dummy
        else
          begin
            old_dummy = @dummy
            @dummy = value
            yield
          ensure
            @dummy = old_dummy
          end
        end
      end

      def now
        if dummy
          dummy.dup
        else
          really_now
        end
      end
    end
  end
end

require 'tins/alias'
