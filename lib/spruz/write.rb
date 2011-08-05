require 'spruz/secure_write'

module Spruz
  module Write
    def self.extended(modul)
      modul.extend SecureWrite
      if modul.respond_to?(:write)
        $DEBUG and warn "Skipping inclusion of Spruz::Write#write method, include Spruz::Write::SecureWrite#secure_write instead"
      else
        class << modul; self; end.instance_eval do
          alias_method :write, :secure_write
        end
      end
      super
    end
  end
end
