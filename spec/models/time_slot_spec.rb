require 'spec_helper'

describe Reservation::TimeSlot do

  it "should be a Reservation::TimeSlot" do
    Reservation::TimeSlot.new.should be_an_instance_of Reservation::TimeSlot
  end

  describe :overlap do
    let(:time_slot) { Reservation::TimeSlot.new :start => (Time.now - 12.hours), :finish => (Time.now - 6.hours) }

    it "should be in range of last 24 hours" do
      time_slot.overlap?(Time.now - 24.hours, Time.now).should == true
    end

    it "should be in range of previous 24 hours" do
      time_slot.overlap?(Time.now - 48.hours, Time.now - 24.hours).should == false
    end

    it "should not be in range of next 24 hours" do
      time_slot.overlap?(Time.now, Time.now + 24.hours).should == false
    end

    it "should overlap with last 9 hours" do
      time_slot.overlap?(Time.now - 9.hours, Time.now).should == true
    end

    it "should overlap with previous 9 hours" do
      time_slot.overlap?(Time.now - 18.hours, Time.now - 9.hours).should == true
    end
  end
end
