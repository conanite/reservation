module Reservation
  module Schedule
    #
    # Weekly defines a set of intervals that recur weekly
    #
    # This class maintains an array of weekdays with an interval for each
    #
    # This class will never match multi-day events, as it assumes each event starts and ends within the same day
    #
    class Weekly

      # wdays is an array of Daily instances
      attr_accessor :wdays

      # pattern is an array of the form
      #
      #  [ { "nth_of_month" => "all", "day" => "wed", "start" => "0930", "finish" => "10:30"},
      #    { "nth_of_month" =>   "1", "day" => "wed", "start" => "18",   "finish" => "20"   },
      #    { "nth_of_month" =>  "-1", "day" => "tue", "start" => "7",    "finish" => "8h30" }  ]
      #
      # see HourMinute#parse for how "start" and "finish" values are read
      #
      # "nth_of_month" => "all", "day" => "mon" :: all mondays in the month are considered
      # "nth_of_month" =>   "1", "day" => "fri" :: only the first friday of the month is considered
      # "nth_of_month" =>  "-1", "day" => "tue" :: only the last tuesday of the month is considered
      # "nth_of_month" =>  "-2", "day" => "sat" :: only the second-last saturday of the month is considered
      #
      def initialize patterns
        self.wdays = []

        patterns.each { |pattern|
          day = pattern["day"]
          dayno = (day =~ /\d+/) ? day.to_i : DAY_MAP[day]

          nth_of_month = parse_nth_of_month pattern["nth_of_month"]

          if pattern["intervals"]
            intervals = Interval.parse(pattern["intervals"])
            self.wdays.concat intervals.map { |i| Daily.new(dayno, nth_of_month, i) }
          else
            start  = HourMinute.parse pattern["start"]
            finish = HourMinute.parse pattern["finish"]
            self.wdays << Daily.new(dayno, nth_of_month, Interval.new(start, finish))
          end
        }
      end

      # true if there exists a Daily corresponding to this event's weekday, with
      # an Interval corresponding to this event's start and finish times;
      # false otherwise
      #
      def matches? event
        return false if event.start.day != event.finish.day
        self.wdays.each { |wday| return true if wday.matches?(event) }
        false
      end

      #
      # generate a set of Events according to this Weekly schedule, starting
      # on #from at the earliest, ending on #upto at the latest.
      #
      # Note: #upto is *inclusive*, this will generate events on #upto,
      # if the schedule allows
      #
      def generate from, upto
        events = []
        from.upto(upto).map { |date|
          wdays.each { |day| day.generate date, events }
        }
        events
      end

      #
      # return a new list including only those events in the given list
      # that match this weekly schedule
      #
      def filter events
        events.select { |e| matches? e }
      end

      def to_s
        wdays.map(&:to_s).join "\n"
      end

      def parse_nth_of_month txt
        (txt.to_s == '' || txt.to_s == 'all') ? :all : txt.to_i
      end
    end
  end
end
