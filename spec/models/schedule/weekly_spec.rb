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

  it "should generate events corresponding to the weekly schedule" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "wed", "start" => "0930", "finish" => "10:30"},
                                                 { "day" => "wed", "start" => "18",   "finish" => "20"   },
                                                 { "day" => "fri", "start" => "10h",   "finish" => "11:45" },
                                                 { "day" => "tue", "start" => "7",    "finish" => "8h30" }  ]

    events = weekly.generate date("2013-07-08"), date("2013-07-23")
    events.map { |e| "#{e.start.prettyd} #{e.finish.pretty}"}.join("\n").
      should == "Tue,20130709T0700 20130709T0830
Wed,20130710T0930 20130710T1030
Wed,20130710T1800 20130710T2000
Fri,20130712T1000 20130712T1145
Tue,20130716T0700 20130716T0830
Wed,20130717T0930 20130717T1030
Wed,20130717T1800 20130717T2000
Fri,20130719T1000 20130719T1145
Tue,20130723T0700 20130723T0830"
  end

  it "should filter a set of events" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "wed", "start" => "0930", "finish" => "10:30"},
                                                 { "day" => "wed", "start" => "18",   "finish" => "20"   },
                                                 { "day" => "fri", "start" => "10h",   "finish" => "11:45" },
                                                 { "day" => "tue", "start" => "7",    "finish" => "8h30" }  ]

    events = weekly.generate date("2013-07-08"), date("2013-07-23")

    filter = Reservation::Schedule::Weekly.new [ { "day" => "wed", "start" => "0930", "finish" => "10:30"} ]

    events = filter.filter events
    events.map { |e| "#{e.start.prettyd} #{e.finish.pretty}"}.join("\n").
      should == "Wed,20130710T0930 20130710T1030
Wed,20130717T0930 20130717T1030"
  end
end
