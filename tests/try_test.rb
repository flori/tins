require 'test_helper'
require 'tins/xt'

module Tins
  class TryTest < Test::Unit::TestCase

    def test_attempt_block_condition
      assert attempt(:attempts => 1, :exception_class => nil) { |c| c == 1 }
      assert attempt(:attempts => 3, :exception_class => nil) { |c| c == 1 }
      assert_equal false, attempt(:attempts => 3, :exception_class => nil) { |c| c == 4 }
      assert_nil attempt(:attempts => 0, :exception_class => nil) { |c| c == 4 }
      assert_raise(Exception) { attempt(:attempts => 3, :exception_class => nil) { raise Exception } }
    end

    class MyError < StandardError; end
    class MyException < Exception; end

    def test_attempt_default_exception
      assert attempt(1) { |c| c != 1 and raise MyError }
      assert attempt(3) { |c| c != 1 and raise MyError }
      assert_equal false, attempt(3) { |c| c != 4 and raise MyError }
      assert_nil attempt(0) { |c| c != 4 and raise MyError }
      assert_raise(Exception) { attempt(3) { raise Exception } }
    end

    def test_attempt_exception
      assert attempt(:attempts => 1, :exception_class => MyException) { |c| c != 1 and raise MyException }
      assert attempt(:attempts => 3, :exception_class => MyException) { |c| c != 1 and raise MyException }
      assert_nil attempt(:attempts => 0, :exception_class => MyException) { |c| c != 4 and raise MyException }
      assert_raise(Exception) { attempt(:attempts => 3, :exception_class => MyException) { raise Exception } }
    end

    def test_reraise_exception
      tries = 0
      assert_raise(MyException) { attempt(:attempts => 3, :exception_class => MyException, :reraise => true) { |c| tries = c; raise MyException } }
      assert_equal 3, tries
    end
  end
end
