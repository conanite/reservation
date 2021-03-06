module Reservation
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
        hhmm = hhmm.gsub(/[^\d]/, "")
        hhmm = "0#{hhmm}00" if hhmm.length == 1
        hhmm = "#{hhmm}00" if hhmm.length == 2
        hhmm = "0#{hhmm}" if hhmm.length == 3
        raise "Can't parse #{orig.inspect}" unless hhmm.match(/^\d\d\d\d$/)

        hh = hhmm[0,2].to_i
        mm = hhmm[2,4].to_i

        new hh, mm
      end

      def change date
        date.to_time.change :hour => hour, :min => minute
      end

      def to_s
        "#{hour.to_s.rjust 2, "0"}#{minute.to_s.rjust 2, "0"}"
      end
    end
  end
end
