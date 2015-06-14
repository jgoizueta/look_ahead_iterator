require "look_ahead_iterator/version"

class LookAheadIterator

  # A LookAheadIterator can be created from any enumerable object.
  #
  # Options:
  #
  # * :stop : If true, the iteration will stop by throwing +StopIteration+
  #   like other external iterators. This will end a +loop+.
  #   Otherwise the user must check of end of iteration by
  # * :end : is used to define a special value to be returned
  #   if the iteration has ended (or when looking beyond the end of the
  #   collection). By default it is +nil+.
  #
  def initialize(enumerable, options = {})
    @end_value = options[:end]
    @stop = options[:stop]
    @iterator = enumerable.each
    @iterator_ended = false
    @buffer = []
    @current = nil
    @ended = false
  end

  attr_reader :current, :end_value

  def each
    if @stop
      loop do
        yield self.next
      end
    else
      yield self.next while next?
    end
  end

  include Enumerable

  def next
    if @buffer.size > 0
      @current = @buffer.shift
    else
      if @stop
        begin
          @current = @iterator.next
        rescue StopIteration
          @iterator_ended = @ended = true
          @current = @end_value
          raise
        end
      else
        @current = next_or_end
        @ended = @iterator_ended
        @current
      end
    end
  end

  def ended?
    # If @end_value cannot be contained in the collection,
    # then this is equivalent to:
    #   @buffer.empty? && @current = @end_value
    @ended
  end

  def next?
    # If @end_value cannot be contained in the collection,
    # then this is equivalent to:
    #   !ended? && (look_ahead(1) != @end_value)
    !ended? && (look_ahead(1); !(@iterator_ended && @buffer.size==0))
  end

  # This method is used to obtained the next value to be
  # returned by +each+. If a parameter +n+ is passed
  # the value to be returned after +n+ calls to +each+ is
  # returned. The value 0 can be used to return the current
  # value (from the previous call to +each+),
  def look_ahead(n=1)
    raise "Can't look back!" if n < 0
    return @current if n == 0

    while n > @buffer.size && !@iterator_ended
      value = next_or_end
      @buffer << value unless @iterator_ended
    end
    n <= @buffer.size ? @buffer[n-1] : @end_value
  end

  def is_end?(value)
    value == @end_value
  end

  def is_valid?(value)
    value != @end_value
  end

private

  def next_or_end
    return @end_value if @ended
    begin
      @iterator.next
    rescue StopIteration
      @iterator_ended = true
      @end_value
    end
  end

end
