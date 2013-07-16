
require "reservation/schedule"
require "reservation/scopes"
require "reservation/event_filter"
require "reservation/event"
require "reservation/reservation"


module Reservation
  def self.table_name_prefix
    'reservation_'
  end
end
