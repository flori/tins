require 'spruz/count_by'

module Spruz
  module ::Enumerable
    include CountBy
  end

  class ::Array
    include CountBy
  end
end
