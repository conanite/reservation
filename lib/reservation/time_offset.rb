module Reservation
  module TimeOffset
    def parse_time_offset hhmm
      orig = hhmm
      hhmm = hhmm.gsub /[^\d]/, ""
      hhmm = "0#{hhmm}00" if hhmm.length == 1
      hhmm = "#{hhmm}00" if hhmm.length == 2
      hhmm = "0#{hhmm}" if hhmm.length == 3
      raise "Can't parse #{orig.inspect}" unless hhmm.match(/^\d\d\d\d$/)

      hh = hhmm[0,2].to_i
      mm = hhmm[2,4].to_i

      { :hour => hh, :min => mm }
    end
  end
end
