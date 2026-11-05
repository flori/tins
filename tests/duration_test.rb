require 'test_helper'

module Tins
  class DurationTest < Test::Unit::TestCase
    def test_short_to_s
      assert_equal '00:11:06', Tins::Duration.new(666).to_s
    end

    def test_to_s_with_days
      assert_equal '7+17:11:06', Tins::Duration.new(666666).to_s
    end

    def test_to_s_with_fractional_seconds
      assert_equal '00:11:06.123', Tins::Duration.new(666.123456).to_s
    end

    def test_to_s_with_days_and_fractional_seconds
      assert_equal '7+17:11:06.123', Tins::Duration.new(666666.123456).to_s
    end

    def test_format_without_precision
      assert_equal '0+00:11:06.123456', Tins::Duration.new(666.123456).format
    end

    def test_format_percentage
      assert_equal '11%06', Tins::Duration.new(666.123456).format('%m%%%s')
    end

    def test_smart_format
      assert_equal '00:11:06.123', Tins::Duration.new(666.123456).format('%D')
      assert_equal '7+17:11:06.123', Tins::Duration.new(666666.123456).format('%D')
    end

    def test_predicate_days
      s = 0
      assert_false Tins::Duration.new(s).days?
      s += 86_400
      assert_true Tins::Duration.new(s).days?
    end

    def test_predicate_hours
      s = 0
      assert_false Tins::Duration.new(s).hours?
      s += 3600
      assert_true Tins::Duration.new(s).hours?
    end

    def test_predicate_minutes
      s = 0
      assert_false Tins::Duration.new(s).minutes?
      s += 60
      assert_true Tins::Duration.new(s).minutes?
    end

    def test_predicate_seconds
      s = 0
      assert_false Tins::Duration.new(s).seconds?
      s += 1
      assert_true Tins::Duration.new(s).seconds?
    end

    def test_predicate_fractional_seconds
      s = 0
      assert_false Tins::Duration.new(s).fractional_seconds?
      s += 0.1
      assert_true Tins::Duration.new(s).fractional_seconds?
    end

    def test_comparison
      t1 = Tins::Duration.new(666.23456)
      t2 = Tins::Duration.new(666.12345)
      assert_operator t1, :>, t2
    end

    def test_negative_durations
      duration = Tins::Duration.new(-42)
      assert_equal '-0+00:00:42.000000', duration.format
      assert_equal '-00:00:42', duration.to_s
      assert_true duration.negative?
      assert_false Tins::Duration.new(42).negative?
    end

    def test_parse_roundtrip
      duration_string = '6+05:04:03.210'
      seconds = Tins::Duration.parse(duration_string)
      assert_equal duration_string, Tins::Duration.new(seconds).to_s
    end

    def test_parse_duration_instance
      duration_string = '6+05:04:03.210'
      duration = Tins::Duration.new(536643.21)
      seconds = Tins::Duration.parse(duration)
      assert_equal duration_string, Tins::Duration.new(seconds).to_s
    end

    def test_parse_percentage
      duration_string = '1%2'
      seconds = Tins::Duration.parse(duration_string, template: '%h%%%m')
      assert_equal 3720, seconds
    end

    def test_format_unpadded_directives
      d = Tins::Duration.new(93_784) # 1d 2h 3m 4s
      assert_equal(
        '1 day(s), 2 hours, 3 minutes, and 4 seconds',
        d.format('%d day(s), %H hours, %M minutes, and %u seconds')
      )
      assert_equal '2', d.format('%H')
      assert_equal '3', d.format('%M')
      assert_equal '4', d.format('%u')
    end

    def test_parse_raises_on_literal_mismatch
      assert_raise(Tins::Duration::ParserError) do
        Tins::Duration.parse('1x:30', template: '%h:%m')
      end
    end

    def test_parse_raises_on_percent_mismatch
      assert_raise(Tins::Duration::ParserError) do
        Tins::Duration.parse('1x', template: '%h%%%m')
      end
    end

    def test_parser_error_is_argument_error
      assert_operator(Tins::Duration::ParserError, :<, ArgumentError)
    end

    def test_parse_template_array_first_match_wins
      # Both templates match '53' but yield different values; order decides.
      assert_equal 190_800,
        Tins::Duration.parse('53', template: [ '%h', '%m' ])
      assert_equal 3180,
        Tins::Duration.parse('53', template: [ '%m', '%h' ])
    end

    def test_parse_template_array_second_match
      # First template fails on the string, second succeeds.
      assert_equal 18_243,
        Tins::Duration.parse('05:04:03',
          template: [ '%S%d+%h:%m:%s.%f', '%h:%m:%s' ])
    end

    def test_parse_template_array_single_element
      # A one-element array behaves like a plain template string.
      assert_equal 18_243,
        Tins::Duration.parse('05:04:03', template: [ '%h:%m:%s' ])
    end

    def test_parse_template_array_none_match
      assert_raise(Tins::Duration::ParserError) do
        Tins::Duration.parse('1x:30',
          template: [ '%h:%m', '%S%d+%h:%m:%s' ])
      end
    end

    def test_from_string_default
      d = Tins::Duration.from_string('6+05:04:03.210')
      assert_instance_of Tins::Duration, d
      assert_in_delta 536_643.21, d.to_f, 1e-9
      assert_equal '6+05:04:03.210', d.to_s
    end

    def test_from_string_custom_template
      d = Tins::Duration.from_string('05:04:03', template: '%h:%m:%s')
      assert_in_delta 18_243.0, d.to_f, 1e-9
    end

    def test_from_string_negative
      d = Tins::Duration.from_string(
        '-00:00:42', template: '%S%h:%m:%s'
      )
      assert_true d.negative?
      assert_in_delta 42.0, d.to_f, 1e-9
    end

    def test_from_string_raises_on_mismatch
      assert_raise(Tins::Duration::ParserError) do
        Tins::Duration.from_string('1x:30', template: '%h:%m')
      end
    end

    def test_from_string_roundtrip
      d = Tins::Duration.new(93_784)
      assert_equal d, Tins::Duration.from_string(
        d.to_s, template: '%d+%h:%m:%s'
      )
    end

    def test_to_human_basic
      assert_equal '1m and 30s', Tins::Duration.new(90).to_human
    end

    def test_to_human_drops_below_max
      assert_equal '1h and 2m', Tins::Duration.new(3725).to_human(max: 2)
    end

    def test_to_human_single_unit
      assert_equal '1d', Tins::Duration.new(86_400).to_human
    end

    def test_to_human_zero
      assert_equal '0s', Tins::Duration.new(0).to_human
    end

    def test_to_human_negative
      assert_equal '-1m and 30s', Tins::Duration.new(-90).to_human
    end

    def test_to_human_custom_max
      assert_equal '1h, 2m, and 5s',
        Tins::Duration.new(3725).to_human(max: 3)
    end

    def test_to_human_custom_two_words_connector
      assert_equal '1h 2m',
        Tins::Duration.new(3725).to_human(max: 2, two_words_connector: ' ')
    end

    def test_to_human_custom_words_connector
      assert_equal '1h / 2m / 5s',
        Tins::Duration.new(3725).to_human(
          max: 3, words_connector: ' / ', last_word_connector: ' / '
        )
    end

    def test_to_human_truncates_fractional
      assert_equal '1m and 30s', Tins::Duration.new(90.999).to_human
    end

    def test_to_human_style_words
      assert_equal '1 minutes and 30 seconds',
        Tins::Duration.new(90).to_human(style: :words)
    end

    def test_to_human_style_words_drops_below_max
      assert_equal '1 hours and 2 minutes',
        Tins::Duration.new(3725).to_human(max: 2, style: :words)
    end

    def test_to_human_style_custom_hash
      assert_equal '1 Min. and 30 Sek.',
        Tins::Duration.new(90).to_human(
          style: { '%m' => ' Min.', '%s' => ' Sek.' }
        )
    end

    def test_to_human_style_custom_hash_partial_merge
      assert_equal '1m and 30 seconds',
        Tins::Duration.new(90).to_human(style: { '%s' => ' seconds' })
    end

    def test_to_human_style_invalid_raises
      assert_raise(ArgumentError) do
        Tins::Duration.new(90).to_human(style: 'abbrev')
      end
    end

    def test_human_styles_keys
      %i[abbrev words].each do |style|
        assert_equal [ '%d', '%h', '%m', '%s' ],
          Tins::Duration::HUMAN_STYLES[style].keys
      end
    end
  end
end
