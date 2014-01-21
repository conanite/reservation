require 'core_ext/date'

module Reservation
  module Schedule
    #
    # a utility class to represent an interval starting on a day
    #
    class Daily
      attr_accessor :wday, :nth_of_month, :interval

      def initialize wday, nth_of_month, interval
        @wday = wday
        @nth_of_month = nth_of_month
        @interval = interval
      end

      def matches? event
        good_day?(event.start.to_date) && interval.matches?(event)
      end

      def generate date, list
        return list unless good_day?(date)
        list << interval.generate(date)
        list
      end

      def good_day? date
        (date.wday == self.wday) && ((self.nth_of_month == :all) || date.nth_day_of_month?(self.nth_of_month))
      end

      def to_s
        "#{MAP_DAY[wday]} => #{interval}"
      end
    end
  end
end
