require 'spruz'

module Spruz
  require 'spruz/string_camelize'
  class ::String
    include StringCamelize
  end
end
