require 'spruz/round'

module Spruz
  module Round
    class ::Float
      include Round
    end

    class ::Integer
      include Round
    end
  end
end
