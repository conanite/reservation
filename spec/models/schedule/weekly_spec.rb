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

  it "should match when there exists a matching interval on the same day as the given event and the day is given as numeric" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "3", "start" => "0930", "finish" => "10:30"},
                                                 { "day" => "3", "start" => "18",   "finish" => "20"   },
                                                 { "day" => "5", "start" => "7h",   "finish" => "9:30" },
                                                 { "day" => "2", "start" => "7",    "finish" => "8h30" }  ]

    weekly.matches?(event).should be_true
  end

  it "should match when there exists a matching interval on the same day as the given event and the day is given as numeric and intervals as a list" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "3", "intervals" => "7-830, 9h00-12:30,13-1730" },
                                                 { "day" => "3", "intervals" => "7-830, 9h00-12:30,13-1730" },
                                                 { "day" => "5", "intervals" => "9h00-12:30,7-930,13-1730 " },
                                                 { "day" => "2", "intervals" => "7-830, 9h00-12:30,13-1730" }  ]

    weekly.matches?(event).should be_true
  end

  it "should not match when there exists no matching interval on the same day as the given event" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "wed", "start" => "0930", "finish" => "10:30"},
                                                 { "day" => "wed", "start" => "18",   "finish" => "20"   },
                                                 { "day" => "fri", "start" => "7h",   "finish" => "8:30" },
                                                 { "day" => "tue", "start" => "7",    "finish" => "8h30" }  ]

    weekly.matches?(event).should be_false
  end

  it "should not match when there exists a matching interval on the same day as the given event and the day is given as numeric and intervals as a list" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "3", "intervals" => "7-830, 9h00-12:30,13-1730" },
                                                 { "day" => "3", "intervals" => "7-830, 9h00-12:30,13-1730" },
                                                 { "day" => "5", "intervals" => "9h00-12:30,7-1130,13-1730 " },
                                                 { "day" => "2", "intervals" => "7-830, 9h00-12:30,13-1730" }  ]

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

  it "should generate events for the fourth-last and second-last friday of each month" do
    weekly = Reservation::Schedule::Weekly.new [ { "day" => "fri", "start" => "10h",   "finish" => "11:45", "nth_of_month" => "-4" },
                                                 { "day" => "fri", "start" => "10h",   "finish" => "11:45", "nth_of_month" => "-2" } ]

    events = weekly.generate date("2013-01-01"), date("2013-12-31")
    events.map { |e| "#{e.start.prettyd} #{e.finish.pretty}"}.join("\n").
      should == "Fri,20130104T1000 20130104T1145
Fri,20130118T1000 20130118T1145
Fri,20130201T1000 20130201T1145
Fri,20130215T1000 20130215T1145
Fri,20130308T1000 20130308T1145
Fri,20130322T1000 20130322T1145
Fri,20130405T1000 20130405T1145
Fri,20130419T1000 20130419T1145
Fri,20130510T1000 20130510T1145
Fri,20130524T1000 20130524T1145
Fri,20130607T1000 20130607T1145
Fri,20130621T1000 20130621T1145
Fri,20130705T1000 20130705T1145
Fri,20130719T1000 20130719T1145
Fri,20130809T1000 20130809T1145
Fri,20130823T1000 20130823T1145
Fri,20130906T1000 20130906T1145
Fri,20130920T1000 20130920T1145
Fri,20131004T1000 20131004T1145
Fri,20131018T1000 20131018T1145
Fri,20131108T1000 20131108T1145
Fri,20131122T1000 20131122T1145
Fri,20131206T1000 20131206T1145
Fri,20131220T1000 20131220T1145"
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
