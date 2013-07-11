class Reservation::Event < ActiveRecord::Base
  has_many :reservations, :class_name => "Reservation::Reservation"
  attr_accessible :finish, :start, :title

  scope :since, lambda { |time| where("reservation_events.finish > ?", time) }
  scope :upto,  lambda { |time| where("reservation_events.start  < ?", time) }

  def overlap? range_start, range_end
    (range_end > start) && (range_start < finish)
  end
end
