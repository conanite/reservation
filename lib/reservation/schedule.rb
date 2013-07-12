module Reservation
  DAY_MAP = { "sun" => 0, "mon" => 1, "tue" => 2, "wed" => 3, "thu" => 4, "fri" => 5, "sat" => 6 }
  MAP_DAY = %w{ sun mon tue wed thu fri sat }

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

      def change date
        date.to_time.change :hour => hour, :min => minute
      end

      def to_s
        "#{hour.to_s.rjust 2, "0"}#{minute.to_s.rjust 2, "0"}"
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

      def generate date, list
        return list if date.wday != wday
        intervals.inject(list) { |list, interval|
          list << interval.generate(date)
          list
        }
      end

      def to_s
        "#{MAP_DAY[wday]} => #{intervals}"
      end
    end

    #
    # Weekly defines a set of intervals that recur weekly
    #
    # This class maintains an array of intervals for each weekday
    #
    # This class will never match multi-day events, as it assumes each event starts and ends within the same day
    #
    class Weekly

      # wdays is a 7-element array of Daily instances
      #
      # the zeroth element corresponds to Sunday, because Time#wday behaves that way.
      #
      attr_accessor :wdays

      # pattern is an array of the form
      #
      #  [ { "day" => "wed", "start" => "0930", "finish" => "10:30"},
      #    { "day" => "wed", "start" => "18",   "finish" => "20"   },
      #    { "day" => "tue", "start" => "7",    "finish" => "8h30" }  ]
      #
      # see HourMinute#parse for how "start" and "finish" values are read
      #
      def initialize pattern
        self.wdays = (0..6).map { |i| Daily.new(i) }

        pattern.each { |interval_spec|
          wday   = DAY_MAP[interval_spec["day"]]
          raise "unrecognised day #{spec["day"].inspect} in #{pattern.inspect}" if wday.nil?

          start  = HourMinute.parse interval_spec["start"]
          finish = HourMinute.parse interval_spec["finish"]
          wdays[wday].add Interval.new(start, finish)
        }
      end

      # true if there exists a Daily corresponding to this event's weekday, with
      # an Interval corresponding to this event's start and finish times;
      # false otherwise
      #
      def matches? event
        return false if event.start.day != event.finish.day
        wdays[event.start.wday].matches? event
      end

      def to_s
        wdays.map(&:to_s).join "\n"
      end
    end
  end
end
