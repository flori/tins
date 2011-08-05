require 'spruz/secure_write'

module Spruz
  #class ::Object
  #  include Spruz::SecureWrite
  #end

  class ::IO
    extend Spruz::SecureWrite
  end
end
