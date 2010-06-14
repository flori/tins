require 'spruz/write'

module Spruz
  #class ::Object
  #  include Spruz::Write
  #end

  class ::IO
    extend Spruz::Write
  end
end
