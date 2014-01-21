class Date
  def nth_day_of_month
    1 + ( (self.mday - 1) / 7 )
  end

  def nth_last_day_of_month
    last_day = self.end_of_month.mday
    - 1 - (last_day - self.mday) / 7
  end

  #
  # return true if this is the nth of this day within the month,
  # for example, if n is 2, and this is the second wednesday of the month,
  # return true. If n is -1, and this is the last saturday of the month,
  # return true. It doesn't matter which *day* it is, it matters whether
  # it's the first, second, third, etc, or if it's the last, second last,
  # third last, etc
  #
  def nth_day_of_month? n
    case n <=> 0
    when -1
      nth_last_day_of_month == n
    when 0
      raise ArgumentError.new("must be non-zero integer")
    when 1
      nth_day_of_month == n
    end
  end
end
