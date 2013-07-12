module Reservation
  module EventFilter
    def filter_events options
      from = options["from"]
      upto = options["upto"]
      context = options["context"]
      schedule = options["schedule"]

      events = ::Reservation.events

      if from
        from = from.respond_to?(:to_date) ? from.to_date : Date.parse(from)
        events = events.since(from)
      end

      if upto
        upto = upto.respond_to?(:to_date) ? upto.to_date : Date.parse(upto) if upto
        events = events.upto(upto) if upto
      end

      if context
        events = events.reserved_for(context) if context
      end

      if schedule
        schedule = ::Reservation::Schedule::Weekly.new schedule
        events = schedule.filter events
      end

      events
    end
  end
end
