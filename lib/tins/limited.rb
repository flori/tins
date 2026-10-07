require 'thread'

module Tins
  # Tins::Limited provides a thread pool implementation that limits the number
  # of concurrent threads running simultaneously.
  #
  # This class implements a producer-consumer pattern where you can submit
  # tasks that will be executed by a fixed number of worker threads, preventing
  # resource exhaustion from too many concurrent operations.
  #
  # @example Basic usage
  #   limited = Tins::Limited.new(3)  # Limit to 3 concurrent threads
  #
  #   limited.process do |l|
  #     10.times do
  #       l.execute { puts "Task #{Thread.current.object_id}" }
  #     end
  #     l.stop  # Stop processing new tasks
  #   end
  #
  # @example With named thread group
  #   limited = Tins::Limited.new(5, name: 'worker_pool')
  #   # Threads will be named 'worker_pool'
  class Limited
    # Create a Limited instance that runs at most _maximum_ threads
    # simultaneously.
    #
    # @param maximum [Integer] The maximum number of concurrent worker threads
    # @param name [String, nil] Optional name for the thread group
    # @raise [ArgumentError] if maximum is less than 1
    # @raise [TypeError] if maximum cannot be converted to Integer
    def initialize(maximum, name: nil)
      @maximum  = Integer(maximum)
      raise ArgumentError, "maximum < 1" if @maximum < 1
      @mutex    = Mutex.new
      @continue = ConditionVariable.new
      @name     = name
      @count    = 0
      @tg       = ThreadGroup.new
    end

    # The maximum number of worker threads that can run concurrently.
    #
    # @return [Integer] The maximum concurrent thread limit
    attr_reader :maximum

    # Submit a task to be executed by the thread pool.
    #
    # @yield [Thread] The block to execute as a task
    # @raise [ArgumentError] if called before process has been started
    def execute(&block)
      @tasks or raise ArgumentError, "start processing first"
      @tasks << block
    end

    # Start processing tasks with the configured thread pool.
    #
    # This method blocks until all tasks are completed and the processing is
    # stopped. The provided block is called repeatedly to submit tasks via
    # execute().
    #
    # @yield [Limited] The limited instance for submitting tasks
    # @return [void]
    def process
      @tasks    = Queue.new
      @executor = create_executor
      @executor.name = @name if @name
      catch :stop do
        loop do
          yield self
        end
      ensure
        @tasks << nil
        @executor.join
        wait
      end
    end

    # Stop processing new tasks and wait for existing tasks to complete.
    #
    # @return [void]
    def stop
      throw :stop
    end

    private

    # Wait for all threads in the thread group to complete.
    #
    # @return [void]
    def wait
      @tg.list.each(&:join)
    end

    # Create and start the executor thread that manages the worker pool.
    #
    # @return [Thread] The executor thread
    def create_executor
      Thread.new do
        @mutex.synchronize do
          loop do
            if @count < @maximum
              task = @tasks.pop or break
              @count += 1
              thread = Thread.new do
                task.(Thread.current)
              ensure
                @count -= 1
                @continue.signal
              end
              @tg.add thread
            else
              @continue.wait(@mutex)
            end
          end
        end
      end
    end
  end
end
