require 'spec_helper'

describe Reservation::Schedule::Daily do
  before { Time.zone = "Europe/Paris" }
  let(:event_start)  { time("2013-07-12T07:00:00") }
  let(:event_finish) { time("2013-07-12T09:30:00") }
  let(:event)        { Reservation::Event.new :start => event_start, :finish => event_finish }

  def interval start, finish
    start  = Reservation::Schedule::HourMinute.parse start
    finish = Reservation::Schedule::HourMinute.parse finish
    Reservation::Schedule::Interval.new(start, finish)
  end

  it "should match when there exists a matching interval on the same day as the given event" do
    daily = Reservation::Schedule::Daily.new(5)
    daily.add interval("7h", "9:30")
    daily.add interval("18", "2230")

    daily.matches?(event).should be_true
  end

  it "should not match when the day is different" do
    daily = Reservation::Schedule::Daily.new(3)
    daily.add interval("7h", "9:30")
    daily.add interval("18", "2230")

    daily.matches?(event).should be_false
  end

  it "should not match when there is no corresponding interval" do
    daily = Reservation::Schedule::Daily.new(5)
    daily.add interval("7h", "9:45")
    daily.add interval("18", "2230")

    daily.matches?(event).should be_false
  end

  it "should generate events corresponding to its intervals on the given matching date" do
    daily = Reservation::Schedule::Daily.new(5)
    daily.add interval("7h", "9:45")
    daily.add interval("18", "2230")

    events = []
    daily.generate date("2013-07-12"), events
    events.map { |e| "#{e.start.prettyd} #{e.finish.pretty}"}.join("\n").
      should == "Fri,20130712T0700 20130712T0945
Fri,20130712T1800 20130712T2230"
  end

  it "should generate no events when the date does not match its weekday" do
    daily = Reservation::Schedule::Daily.new(2)
    daily.add interval("7h", "9:45")
    daily.add interval("18", "2230")

    events = []
    daily.generate date("2013-07-12"), events
    events.should == []
  end
end
