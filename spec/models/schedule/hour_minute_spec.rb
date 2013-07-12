require 'spec_helper'

describe Reservation::Schedule::HourMinute do
  before { Time.zone = "Europe/Paris" }
  let(:rightnow) { time("2013-04-30T18:30:00") }

  it "should match when hours and minutes match" do
    hm = Reservation::Schedule::HourMinute.new 18, 30
    hm.matches_time?(rightnow).should be_true
  end

  it "should not match when minutes differ" do
    hm = Reservation::Schedule::HourMinute.new 18, 31
    hm.matches_time?(rightnow).should be_false
  end

  it "should not match when hours differ" do
    hm = Reservation::Schedule::HourMinute.new 17, 30
    hm.matches_time?(rightnow).should be_false
  end
end
