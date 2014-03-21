module Reservation
  class Reservation < ActiveRecord::Base
    belongs_to :event, :class_name => "Reservation::Event", :inverse_of => :reservations
    belongs_to :subject, :polymorphic => true
  end
end
