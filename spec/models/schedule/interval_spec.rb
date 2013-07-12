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
end
