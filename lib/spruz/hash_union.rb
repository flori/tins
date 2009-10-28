module Spruz
  module HashUnion
    def |(other)
      other = other.to_hash if other.respond_to?(:to_hash)
      other.merge(self)
    end
  end
end
