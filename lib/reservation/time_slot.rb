class Reservation::TimeSlot < ActiveRecord::Base
  has_many :reservations, :class_name => "Reservation::Reservation"
end
