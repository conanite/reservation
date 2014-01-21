require 'reservation/hour_minute'
require 'reservation/interval'
require 'reservation/daily'
require 'reservation/weekly'

module Reservation
  DAY_MAP = { "sun" => 0, "mon" => 1, "tue" => 2, "wed" => 3, "thu" => 4, "fri" => 5, "sat" => 6 }
  MAP_DAY = %w{ sun mon tue wed thu fri sat }
end
