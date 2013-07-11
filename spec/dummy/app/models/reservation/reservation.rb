class Reservation::Reservation < ActiveRecord::Base
  attr_accessible :reservation_status, :role, :subject_id, :subject_type, :time_slot_id
end
