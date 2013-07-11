require 'spec_helper'

describe Reservation::TimeSlot do

  it "should be a Reservation::TimeSlot" do
    Reservation::TimeSlot.new.should be_an_instance_of Reservation::TimeSlot
  end

  describe :in_range do
    let(:time_slot) { Reservation::TimeSlot.new :start => (Time.now - 12.hours), :finish => (Time.now - 6.hours) }

    it "should be in range of last 24 hours" do
      time_slot.in_range?(Time.now - 24.hours, Time.now).should == true
    end

    it "should not be in range of next 24 hours" do
      time_slot.in_range?(Time.now, Time.now + 24.hours).should == false
    end
  end
end
