module Spruz
  module Try
    def try(attempts = 1, exception_class = StandardError, &block)
      return if attempts <= 0
      count = 0
      if exception_class.nil?
        begin
          count += 1
          return true if block.call(count)
        end until count == attempts
        false
      else
        begin
          count += 1
          block.call(count)
          true
        rescue exception_class
          retry if count < attempts
          false
        end
      end
    end
  end
end
