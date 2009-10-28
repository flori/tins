require 'spruz/hash_union'

module Spruz
  class ::Hash
    if method_defined?(:|)
      warn "#{self}#| already defined, didn't include at #{__FILE__}:#{__LINE__}"
    else
      include HashUnion
    end
  end
end
