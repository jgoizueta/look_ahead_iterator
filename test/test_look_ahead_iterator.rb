require 'minitest_helper'

class TestLookAheadIterator < Minitest::Test

  def test_simple_iteration
    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: false)
    refute it.ended?
    assert_equal 11, it.next
    refute it.ended?
    assert_equal 22, it.next
    refute it.ended?
    assert_equal 33, it.next
    refute it.ended?
    assert_equal 44, it.next
    refute it.ended?
    assert_equal 55, it.next
    refute it.ended?
    assert_equal :end, it.next
    assert it.ended?
  end

  def test_iterate_and_look_ahead_with_end_value
    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: false)
    assert it.next?
    refute it.ended?
    assert_equal 11, it.next
    assert_equal 33, it.look_ahead(2)
    assert_equal 22, it.look_ahead(1)
    assert_equal 44, it.look_ahead(3)
    assert_equal 22, it.next
    assert it.next?
    refute it.ended?
    assert_equal 33, it.next
    assert_equal 44, it.next
    assert_equal 55, it.next
    assert_equal :end, it.next
    assert it.ended?

    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: false)
    assert it.next?
    refute it.ended?
    assert_equal 11, it.next
    assert_equal 33, it.look_ahead(2)
    assert_equal 22, it.look_ahead(1)
    assert_equal 44, it.look_ahead(3)
    assert_equal 22, it.next
    assert it.next?
    refute it.ended?
    assert_equal 33, it.next
    assert_equal 44, it.next
    assert it.next?
    assert_equal 55, it.next
    refute it.next?
    refute it.ended?
    assert_equal :end, it.next
    assert it.ended?
  end

  def test_iterate_and_look_ahead_past_end
    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: false)
    assert it.next?
    refute it.ended?
    assert_equal 11, it.next
    assert_equal 33, it.look_ahead(2)
    assert_equal 22, it.look_ahead(1)
    assert_equal 44, it.look_ahead(3)
    assert_equal 22, it.next
    assert it.next?
    refute it.ended?
    assert_equal 33, it.next
    assert_equal 44, it.next
    assert_equal 55, it.look_ahead(1)
    refute it.ended?
    assert it.next?
    assert_equal 55, it.look_ahead(1)
    assert_equal :end, it.look_ahead(2)
    assert_equal :end, it.look_ahead(4)
    refute it.ended?
    assert it.next?
    assert_equal 55, it.next
    refute it.ended?
    assert_equal :end, it.next
    assert it.ended?
    refute it.next?
  end

  def test_iterate_and_look_ahead_with_stop
    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: true)
    assert it.next?
    refute it.ended?
    assert_equal 11, it.next
    assert_equal 33, it.look_ahead(2)
    assert_equal 22, it.look_ahead(1)
    assert_equal 44, it.look_ahead(3)
    assert_equal 22, it.next
    assert it.next?
    refute it.ended?
    assert_equal 33, it.next
    assert_equal 44, it.next
    assert_equal 55, it.next
    assert_raise(StopIteration){ it.next }
    assert it.ended?
    refute it.next?

    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: true)
    assert it.next?
    refute it.ended?
    assert_equal 11, it.next
    assert_equal 33, it.look_ahead(2)
    assert_equal 22, it.look_ahead(1)
    assert_equal 44, it.look_ahead(3)
    assert_equal 22, it.next
    assert it.next?
    refute it.ended?
    assert_equal 33, it.next
    assert_equal 44, it.next
    assert_equal 55, it.look_ahead(1)
    assert_equal :end, it.look_ahead(2)
    assert_equal :end, it.look_ahead(4)
    assert_equal 55, it.next
    assert_equal :end, it.look_ahead(2)
    assert_equal :end, it.look_ahead(1)
    assert_raise(StopIteration){ it.next }
    assert it.ended?
    refute it.next?
  end

  def test_overlapping_look_ahead
    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: false)
    assert it.next?
    refute it.ended?
    assert_equal 11, it.look_ahead
    assert_equal 11, it.next
    assert_equal 33, it.look_ahead(2)
    assert_equal 22, it.look_ahead(1)
    assert_equal 44, it.look_ahead(3)
    assert_equal 22, it.next
    assert_equal 33, it.look_ahead(1)
    assert_equal 44, it.look_ahead(2)
    assert_equal 55, it.look_ahead(3)
    assert_equal 33, it.next
    assert_equal 44, it.look_ahead(1)
    assert_equal 55, it.look_ahead(2)
    assert_equal :end, it.look_ahead(3)
    assert_equal 44, it.next
    assert_equal 55, it.look_ahead(1)
    assert_equal :end, it.look_ahead(2)
    assert_equal :end, it.look_ahead(3)
    assert_equal 55, it.next
    assert_equal :end, it.look_ahead(1)
    assert_equal :end, it.look_ahead(2)
    assert_equal :end, it.look_ahead(3)
    assert_equal :end, it.next
    assert_equal :end, it.look_ahead(1)
    assert_equal :end, it.look_ahead(2)
    assert_equal :end, it.look_ahead(3)
  end

  def test_unreliable_end_value
    # If the end-marking value is contained in the collection,
    # then the user may be confused (checking for the end value doesn't
    # detect the end of the iterator reliably), but the ended? and
    # next? methods should still work reliably.

    # Check ended? without look ahead
    it = LookAheadIterator.new([11,22,nil,44,nil], stop: false)
    assert_nil it.end_value
    assert_equal 11, it.next
    assert_equal 22, it.next
    refute it.ended?
    assert_nil it.next
    refute it.ended?
    assert_equal 44, it.next
    refute it.ended?
    assert_nil it.next
    refute it.ended?
    assert_nil it.next
    assert it.ended?

    # Check next? without look ahead
    it = LookAheadIterator.new([11,22,nil,44,nil], stop: false)
    assert_nil it.end_value
    assert_equal 11, it.next
    assert_equal 22, it.next
    assert it.next?
    assert_nil it.next
    assert it.next?
    assert_equal 44, it.next
    assert it.next?
    assert_nil it.next
    refute it.next?
    assert_nil it.next
    refute it.next?

    # Check ended? with look ahead
    it = LookAheadIterator.new([11,22,nil,44,nil], stop: false)
    assert_nil it.end_value
    assert_equal 11, it.next
    assert_equal 22, it.next
    refute it.ended?
    assert_nil it.look_ahead
    refute it.ended?
    assert_nil it.next
    refute it.ended?
    assert_equal 44, it.look_ahead(1)
    assert_nil it.look_ahead(2)
    assert_nil it.look_ahead(3)
    refute it.ended?
    assert_equal 44, it.next
    refute it.ended?
    assert_nil it.next
    refute it.ended?
    assert_nil it.next
    assert it.ended?

    # Check next? with look ahead
    it = LookAheadIterator.new([11,22,nil,44,nil], stop: false)
    assert_nil it.end_value
    assert_equal 11, it.next
    assert_equal 22, it.next
    assert it.next?
    assert_nil it.next
    assert it.next?
    assert_equal 44, it.look_ahead(1)
    assert_nil it.look_ahead(2)
    assert_nil it.look_ahead(3)
    assert it.next?
    assert_equal 44, it.next
    assert it.next?
    assert_nil it.next
    refute it.next?
    assert_nil it.next
    refute it.next?
  end

  def test_each_with_stop_exception
    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: true)
    result = []
    it.each do |value|
      result << value
    end
    assert_equal [11,22,33,44,55], result
  end

  def test_each_without_stop_exception
    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: false)
    result = []
    it.each do |value|
      result << value
    end
    assert_equal [11,22,33,44,55], result
  end

  def test_enumerable
    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: false)
    assert_equal [11,22,33,44,55], it.to_a
    it = LookAheadIterator.new([11,22,33,44,55], end: :end, stop: false)
    assert_equal [11,22,33,44,55], it.map{|v| v}
  end

end
