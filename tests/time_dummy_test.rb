require 'test_helper'
require 'tins'

module Tins
  class TimeDummyTest < Test::Unit::TestCase
    require 'tins/xt/time_dummy'
    require 'time'

    def test_time_dummy
      time = Time.parse('2009-09-09 21:09:09')
      assert_not_equal time, Time.now
      Time.dummy = time
      assert_equal time, Time.now
      Time.dummy = nil
      assert_not_equal time, Time.now
    end
  end
end
