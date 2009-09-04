module Spruz
  module Uniq
    def uniq_by(&b)
      b ||= lambda { |x| x }
      inject({}) { |h, e| h[b[e]] = e; h }.values
    end
  end

  module ::Enumerable
    include Uniq
  end

  class ::Array
    include Uniq

    def uniq_by!(&b)
      replace uniq_by(&b)
    end
  end
end
