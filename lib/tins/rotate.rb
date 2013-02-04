module Tins
  module Rotate
    def rotate!(n = 1)
      if n >= 0
        n.times { push shift }
      else
        (-n).times { unshift pop }
      end
      self
    end

    def rotate
      clone.rotate!
    end
  end
end
