module Reservation
  DAY_MAP = %w{ sun mon tue wed thu fri sat }

  module Schedule
    class HourMinute
      attr_accessor :hour, :minute
      def initialize hour, minute
        @hour, @minute = hour, minute
      end

      def matches_time? time
        time.hour == self.hour && time.min == self.minute
      end
    end

  end
end
