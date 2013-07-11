class Reservation::Reservation < ActiveRecord::Base
  belongs_to :event, :class_name => "Reservation::Event"
  belongs_to :subject, :polymorphic => true
  attr_accessible :reservation_status, :role, :subject_id, :subject_type, :event_id, :event, :subject
end
