module Reservation
  module Schedule
    #
    # a utility class to match the start and end times of an Event instance, without considering the event date
    #
    class Interval
      attr_accessor :start, :finish

      def initialize start, finish
        @start, @finish = start, finish
      end

      # true if the start time and finish time of the given event matches start and finish times of this Interval
      def matches? event
        start.matches_time?(event.start) && finish.matches_time?(event.finish)
      end

      # build a new Event with this Interval's start and finish times, on the given date
      def generate date
        Event.new :start => start.change(date), :finish => finish.change(date)
      end

      def self.from start, finish
        new HourMinute.parse(start), HourMinute.parse(finish)
      end

      def to_s
        "#{start}-#{finish}"
      end
    end
  end
end
