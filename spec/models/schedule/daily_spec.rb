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
    daily = Reservation::Schedule::Daily.new(5, :all, interval("7h", "9:30"))
    daily.matches?(event).should be_true
  end

  it "should match when there exists a matching interval on the same nth day as the given event" do
    daily = Reservation::Schedule::Daily.new(5, 2, interval("7h", "9:30"))
    daily.matches?(event).should be_true
  end

  it "should match when there exists a matching interval on the same nth-last day as the given event" do
    daily = Reservation::Schedule::Daily.new(5, -3, interval("7h", "9:30"))
    daily.matches?(event).should be_true
  end

  it "should not match when the day is different" do
    daily = Reservation::Schedule::Daily.new(3, :all, interval("7h", "9:30"))
    daily.matches?(event).should be_false
  end

  it "should not match when the nth day is different" do
    daily = Reservation::Schedule::Daily.new(3, 5, interval("7h", "9:30"))
    daily.matches?(event).should be_false
  end

  it "should not match when the nth-last day is different" do
    daily = Reservation::Schedule::Daily.new(3, -1, interval("7h", "9:30"))
    daily.matches?(event).should be_false
  end

  it "should not match when there is no corresponding interval" do
    daily = Reservation::Schedule::Daily.new(5, :all, interval("7h", "9:45"))
    daily.matches?(event).should be_false
  end

  it "should generate events corresponding to its intervals on the given matching date" do
    daily = Reservation::Schedule::Daily.new(5, :all, interval("7h", "9:45"))

    events = []
    daily.generate date("2013-07-12"), events
    actual = events.map { |e| "#{e.start.prettyd} #{e.finish.pretty}"}.join("\n")
    actual.should == "Fri,20130712T0700 20130712T0945"
  end

  it "should generate events corresponding to its intervals on the given matching nth day" do
    daily = Reservation::Schedule::Daily.new(5, 2, interval("7h", "9:45"))

    events = []
    daily.generate date("2013-07-12"), events
    actual = events.map { |e| "#{e.start.prettyd} #{e.finish.pretty}"}.join("\n")
    actual.should == "Fri,20130712T0700 20130712T0945"
  end

  it "should generate events corresponding to its intervals on the given matching nth-last day" do
    daily = Reservation::Schedule::Daily.new(5, -3, interval("7h", "9:45"))

    events = []
    daily.generate date("2013-07-12"), events
    actual = events.map { |e| "#{e.start.prettyd} #{e.finish.pretty}"}.join("\n")
    actual.should == "Fri,20130712T0700 20130712T0945"
  end

  it "should generate no events when the date does not match its weekday" do
    daily = Reservation::Schedule::Daily.new(2, :all, interval("7h", "9:45"))

    events = []
    daily.generate date("2013-07-12"), events
    events.should == []
  end

  it "should generate no events when the date does not match its nth weekday" do
    daily = Reservation::Schedule::Daily.new(2, 5, interval("7h", "9:45"))

    events = []
    daily.generate date("2013-07-12"), events
    events.should == []
  end

  it "should generate no events when the date does not match its nth-last weekday" do
    daily = Reservation::Schedule::Daily.new(2, -1, interval("7h", "9:45"))

    events = []
    daily.generate date("2013-07-12"), events
    events.should == []
  end
end
