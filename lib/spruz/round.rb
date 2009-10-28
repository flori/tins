module Spruz
  # A bit more versatile rounding for Ruby
  module Round
    def self.included(klass)
      if klass.instance_method(:round)
        klass.class_eval do
          begin
            remove_method :round
          rescue NameError
          end
        end
        super
      else
        raise NoMethodError, 'no round method found'
      end
    end

    def round(places = 0)
      unless Integer === places
        raise TypeError, "argument places has to be an Integer"
      end
      if places < 0
        max_places = -Math.log(self.abs + 1) / Math.log(10)
        raise ArgumentError, "places has to be >= #{max_places.ceil}" if max_places > places 
      end
      t = self
      f = 10.0 ** places
      t *= f
      if t >= 0.0
        t = (t + 0.5).floor
      elsif t < 0.0
        t = (t - 0.5).ceil
      end
      t /= f
      t.nan? ? self : t
    end
  end
end
