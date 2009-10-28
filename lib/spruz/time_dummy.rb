module Spruz
  module TimeDummy
    def self.included(modul)
      modul.module_eval do
        class << self
          alias really_new new
        end

        extend ClassMethods

        class << self
          alias now new
        end
      end
    end

    module ClassMethods
      attr_accessor :dummy

      def new
        if dummy
          dummy.dup
        else
          really_new
        end
      end
    end
  end
end
