require 'spruz'

module Spruz
  require 'spruz/string_version'

  class ::String
    include StringVersion
  end
end
