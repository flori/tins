require 'spruz/uniq_by'

module Spruz
  module ::Enumerable
    include UniqBy
  end

  class ::Array
    include UniqBy

    def uniq_by!(&b)
      replace uniq_by(&b)
    end
  end
end
