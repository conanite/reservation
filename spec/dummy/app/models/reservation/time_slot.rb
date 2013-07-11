class Reservation::TimeSlot < ActiveRecord::Base
  attr_accessible :finish, :start, :title
end
