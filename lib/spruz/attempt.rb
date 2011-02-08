module Spruz
  module Attempt
    def attempt(attempts = 1, exception_class = StandardError, sleep_duration = nil, &block)
      return if attempts <= 0
      count = 0
      if exception_class.nil?
        begin
          count += 1
          if block.call(count)
            return true
          elsif sleep_duration and count < attempts
            sleep sleep_duration
          end
        end until count == attempts
        false
      else
        begin
          count += 1
          block.call(count)
          true
        rescue exception_class
          if count < attempts
            sleep_duration and sleep sleep_duration
            retry
          end
          false
        end
      end
    end
  end
end
