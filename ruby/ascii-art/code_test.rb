# frozen_string_literal: true

require 'test/unit'

class TestCode < Test::Unit::TestCase
  def test_add_row
    letter = Letter.new
    letter.add_row('a')
    assert_equal(['a'], letter.rows)
  end

  def test_row
    letter = Letter.new
    assert_equal([], letter.rows)
  end

end


