require 'spruz/range_plus'

module Spruz
  class ::Range
    if method_defined?(:+)
      warn "#{self}#+ already defined, didn't include at #{__FILE__}:#{__LINE__}"
    else
      include RangePlus
    end
  end
end

