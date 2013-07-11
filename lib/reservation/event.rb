class Reservation::Event < ActiveRecord::Base
  has_many :reservations, :class_name => "Reservation::Reservation"
  attr_accessible :finish, :start, :title

  scope :since, lambda { |time| where("reservation_events.finish > ?", time) }
  scope :upto,  lambda { |time| where("reservation_events.start  < ?", time) }
  scope :reserved_for, lambda { |who|
    klass = who.class.base_class.name
    joins("join reservation_reservations rrx on reservation_events.id = rrx.event_id").where("rrx.subject_type = ? and rrx.subject_id = ?", klass, who.id)
  }

  def overlap? range_start, range_end
    (range_end > start) && (range_start < finish)
  end
end
