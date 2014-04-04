require 'test_helper'
require 'tins'

module Tins
  class TimeFreezerTest < Test::Unit::TestCase
    def test_freezing
      freezing_point = '2011-11-11T11:11:11'
      Tins::TimeFreezer.freeze(freezing_point) do
        assert_equal freezing_point, Time.now.strftime('%FT%T')
        assert_equal freezing_point, DateTime.now.strftime('%FT%T')
        assert_equal freezing_point[0, 10], Date.today.strftime('%F')
      end
    end
  end
end
