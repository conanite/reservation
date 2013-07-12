module Reservation
  def self.events
    ::Reservation::Event.scoped
  end

  def self.reservations
    ::Reservation::Reservation.scoped
  end
end

require "reservation/schedule"
require "reservation/event"
require "reservation/reservation"

