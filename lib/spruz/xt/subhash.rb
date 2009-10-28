require 'spruz/subhash'

module Spruz
  class ::Hash
    include Spruz::Subhash

    def subhash!(*patterns)
      replace subhash(*patterns)
    end
  end
end
