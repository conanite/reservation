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

  it "should parse '7' as '0700'" do
    hm = Reservation::Schedule::HourMinute.parse "7"
    hm.hour.should == 7
    hm.minute.should == 0
  end

  it "should parse '11' as '1100'" do
    hm = Reservation::Schedule::HourMinute.parse "11"
    hm.hour.should == 11
    hm.minute.should == 0
  end

  it "should parse '815' as '0815'" do
    hm = Reservation::Schedule::HourMinute.parse "815"
    hm.hour.should == 8
    hm.minute.should == 15
  end

  it "should change a date to a time with the given hour and minute" do
    hm = Reservation::Schedule::HourMinute.parse "815"
    time = hm.change date("2013-07-12")
    time.pretty.should == "20130712T0815"
  end
end
