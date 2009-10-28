require 'spruz/partial_application'

module Spruz
  class ::Proc
    include PartialApplication
  end

  class ::Method
    include PartialApplication
  end
end
