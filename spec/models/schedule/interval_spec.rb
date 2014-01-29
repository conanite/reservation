require 'spec_helper'

describe Reservation::Schedule::Interval do
  before { Time.zone = "Europe/Paris" }

  let(:start)  { time("2013-04-30T18:30:00") }
  let(:finish) { time("2013-04-30T22:30:00") }
  let(:event)  { Reservation::Event.new :start => start, :finish => finish }

  it "should match when start and finish match" do
    hm1 = Reservation::Schedule::HourMinute.new 18, 30
    hm2 = Reservation::Schedule::HourMinute.new 22, 30
    interval = Reservation::Schedule::Interval.new hm1, hm2
    interval.matches?(event).should be_true
  end

  it "should not match when start differs" do
    hm1 = Reservation::Schedule::HourMinute.new 14, 00
    hm2 = Reservation::Schedule::HourMinute.new 22, 30
    interval = Reservation::Schedule::Interval.new hm1, hm2
    interval.matches?(event).should be_false
  end

  it "should not match when finish differs" do
    hm1 = Reservation::Schedule::HourMinute.new 18, 30
    hm2 = Reservation::Schedule::HourMinute.new 23, 00
    interval = Reservation::Schedule::Interval.new hm1, hm2
    interval.matches?(event).should be_false
  end

  it "should generate a new Event with its start and finish times on the given date" do
    interval = make_interval "1830", "2300"
    event = interval.generate date('2013-07-12')
    event.start.pretty.should  == "20130712T1830"
    event.finish.pretty.should == "20130712T2300"
  end

  it "should parse a text list of intervals" do
    intervals = Reservation::Schedule::Interval.parse "9h-12, 12h30-13:30 , 14-17.30"
    intervals[0].to_s.should == "0900-1200"
    intervals[1].to_s.should == "1230-1330"
    intervals[2].to_s.should == "1400-1730"
    intervals.size.should == 3
  end
end
