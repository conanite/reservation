module Reservation
  module EventFilter
    def parse_time_for_upto txt
      d = Date.parse(txt) rescue nil
      t = Time.parse(txt) rescue nil
      raise "can't read date/time #{txt.inspect}" if d.nil? && t.nil?
      if d && (d.to_time == t)
        return (d + 1.day).to_time
      end
      t
    end

    def filter_events options
      from = options["from"]
      upto = options["upto"]
      context = options["context"]
      schedule = options["schedule"]

      events = ::Reservation.events

      if from
        from = from.is_a?(String) ? Date.parse(from) : from.to_date
        events = events.since(from)
      end

      if upto
        upto = upto.is_a?(String) ? parse_time_for_upto(upto) : upto.to_time if upto
        events = events.upto(upto) if upto
      end

      if context
        context = [context] unless context.is_a? Array
        context = context.uniq
        events = context.inject(events) { |ee, ctx|
          ee.reserved_for(ctx)
        }
      end

      if schedule
        schedule = ::Reservation::Schedule::Weekly.new schedule
        events = schedule.filter events
      end

      events
    end
  end
end
