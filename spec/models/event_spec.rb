require 'spec_helper'

describe Reservation::Event do

  it "should be a Reservation::Event" do
    Reservation::Event.new.should be_an_instance_of Reservation::Event
  end

  describe :overlap do
    let(:event) { Reservation::Event.new :start => (Time.now - 12.hours), :finish => (Time.now - 6.hours) }

    it "should be in range of last 24 hours" do
      event.overlap?(Time.now - 24.hours, Time.now).should == true
    end

    it "should be in range of previous 24 hours" do
      event.overlap?(Time.now - 48.hours, Time.now - 24.hours).should == false
    end

    it "should not be in range of next 24 hours" do
      event.overlap?(Time.now, Time.now + 24.hours).should == false
    end

    it "should overlap with last 9 hours" do
      event.overlap?(Time.now - 9.hours, Time.now).should == true
    end

    it "should overlap with previous 9 hours" do
      event.overlap?(Time.now - 18.hours, Time.now - 9.hours).should == true
    end
  end
end
