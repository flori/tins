module Tins
  module Empty
    def respond_to?(name, *)
      if name == :empty?
        find_counter ? true : false
      else
        super
      end
    end

    def empty?
      if counter = find_counter
        counter.call == 0
      else
        raise NoMethodError, "method empty? could not be inferred"
      end
    end

    private

    def find_counter
      [ :size, :length, :count ].find do |c|
        begin
          m = method(c)
          if m.arity <= 0
            break m
          end
        rescue NameError
        end
      end
    end
  end
end
