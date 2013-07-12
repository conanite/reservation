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
end
