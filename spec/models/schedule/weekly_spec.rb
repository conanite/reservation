require 'spec_helper'

describe Reservation::Schedule::Weekly do
  before { Time.zone = "Europe/Paris" }
  let(:event_start)  { time("2013-07-12T07:00:00") } # this is a friday
  let(:event_finish) { time("2013-07-12T09:30:00") }
  let(:event)        { Reservation::Event.new :start => event_start, :finish => event_finish }

  it "should not match in any case if the event spans more than one day" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "wed", "start" => "0930", "finish" => "10:30"},
                                                 { "day" => "wed", "start" => "18",   "finish" => "20"   },
                                                 { "day" => "fri", "start" => "7h",   "finish" => "9:30" },
                                                 { "day" => "tue", "start" => "7",    "finish" => "8h30" }  ]

    start  = time("2013-02-12T07:00:00") # this is a tuesday
    finish = time("2013-03-12T09:30:00")
    my_event = Reservation::Event.new :start => start, :finish => finish

    weekly.matches?(my_event).should be_false
  end

  it "should match when there exists a matching interval on the same day as the given event" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "wed", "start" => "0930", "finish" => "10:30"},
                                                 { "day" => "wed", "start" => "18",   "finish" => "20"   },
                                                 { "day" => "fri", "start" => "7h",   "finish" => "9:30" },
                                                 { "day" => "tue", "start" => "7",    "finish" => "8h30" }  ]

    weekly.matches?(event).should be_true
  end

  it "should not match when there exists no matching interval on the same day as the given event" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "wed", "start" => "0930", "finish" => "10:30"},
                                                 { "day" => "wed", "start" => "18",   "finish" => "20"   },
                                                 { "day" => "fri", "start" => "7h",   "finish" => "8:30" },
                                                 { "day" => "tue", "start" => "7",    "finish" => "8h30" }  ]

    weekly.matches?(event).should be_false
  end
end
