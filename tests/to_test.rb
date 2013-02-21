require 'test_helper'
require 'tins/xt/to'

module Tins
  class ToTest < Test::Unit::TestCase
    def test_to
      doc = to(<<-end)
        hello, world
      end
      assert_equal "hello, world\n", doc
    end
  end
end
