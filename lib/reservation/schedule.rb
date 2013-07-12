module Reservation
  DAY_MAP = { "sun" => 0, "mon" => 1, "tue" => 2, "wed" => 3, "thu" => 4, "fri" => 5, "sat" => 6 }

  module Schedule
    #
    # a utility class to match the hour and minute elements of a Time instance, without considering any other values
    #
    class HourMinute
      attr_accessor :hour, :minute
      def initialize hour, minute
        @hour, @minute = hour, minute
      end

      def matches_time? time
        time.hour == self.hour && time.min == self.minute
      end

      #
      # hhmm is a string containg an hour-and-minute value
      #
      # #parse will remove all nondigit characters, pad the result to 4 digits,
      # and interpret the first two as an hour value, the last two as a minute value
      #
      # padding takes place as follows :
      #  * one digit becomes 0d00 (assumes "7" means "0700")
      #  * two digits become dd00 (assumes "11" means "1100")
      #  * three digits become 0ddd (assumes "830" means "0830")
      #
      def self.parse hhmm
        orig = hhmm
        hhmm = hhmm.gsub /[^\d]/, ""
        hhmm = "0#{hhmm}00" if hhmm.length == 1
        hhmm = "#{hhmm}00" if hhmm.length == 2
        hhmm = "0#{hhmm}" if hhmm.length == 3
        raise "Can't parse #{orig.inspect}" unless hhmm.match(/^\d\d\d\d$/)

        hh = hhmm[0,2].to_i
        mm = hhmm[2,4].to_i

        new hh, mm
      end
    end

    #
    # a utility class to match the start and end times of an Event instance, without considering the event date
    #
    class Interval
      attr_accessor :start, :finish

      def initialize start, finish
        @start, @finish = start, finish
      end

      def matches? event
        start.matches_time?(event.start) && finish.matches_time?(event.finish)
      end
    end

    #
    # a utility class to represent a set of intervals on a single day
    #
    class Daily
      attr_accessor :wday, :intervals

      def initialize wday
        @wday = wday
        @intervals = []
      end

      def add interval
        intervals << interval
      end

      def matches? event
        return false if event.start.wday != self.wday
        intervals.each { |interval|
          return true if interval.matches? event
        }
        false
      end
    end

  end
end
