module Tins
  module To
    def to(string)
      string.gsub(/^\s*/, '')
    end
  end
end
