module Tins
  module ProcCompose
    def compose(other)
      self.class.new { |*args| call(*other.call(*args)) }
    end

    alias * compose
  end
end
