class Reservation::Reservation < ActiveRecord::Base
  belongs_to :time_slot, :class_name => "Reservation::TimeSlot"
  belongs_to :subject, :polymorphic => true
end
