class Reservation::Reservation < ActiveRecord::Base
  belongs_to :time_slot, :class_name => "Reservation::TimeSlot"
  belongs_to :subject, :polymorphic => true
  attr_accessible :reservation_status, :role, :subject_id, :subject_type, :time_slot_id
end
