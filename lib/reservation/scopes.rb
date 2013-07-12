module Reservation
  # replace this if you need to globally override the starting scope for events
  def self.events
    ::Reservation::Event.scoped
  end

  # replace this if you need to globally override the starting scope for reservations
  def self.reservations
    ::Reservation::Reservation.scoped
  end
end
