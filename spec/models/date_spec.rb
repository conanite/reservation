require 'core_ext/date'

describe Date do
  describe :nth_day_of_month do
    it "should return the index of this week-day in the month" do
      expect(Date.new(2014, 1,  1).nth_day_of_month).to eq 1 # this is the first wednesday of the month
      expect(Date.new(2014, 1,  2).nth_day_of_month).to eq 1
      expect(Date.new(2014, 1,  3).nth_day_of_month).to eq 1
      expect(Date.new(2014, 1,  4).nth_day_of_month).to eq 1
      expect(Date.new(2014, 1,  5).nth_day_of_month).to eq 1
      expect(Date.new(2014, 1,  6).nth_day_of_month).to eq 1
      expect(Date.new(2014, 1,  7).nth_day_of_month).to eq 1
      expect(Date.new(2014, 1,  8).nth_day_of_month).to eq 2 # this is the second wednesday of the month
      expect(Date.new(2014, 1,  9).nth_day_of_month).to eq 2
      expect(Date.new(2014, 1, 10).nth_day_of_month).to eq 2
      expect(Date.new(2014, 1, 11).nth_day_of_month).to eq 2
      expect(Date.new(2014, 1, 12).nth_day_of_month).to eq 2
      expect(Date.new(2014, 1, 13).nth_day_of_month).to eq 2
      expect(Date.new(2014, 1, 14).nth_day_of_month).to eq 2
      expect(Date.new(2014, 1, 15).nth_day_of_month).to eq 3
      expect(Date.new(2014, 1, 16).nth_day_of_month).to eq 3
      expect(Date.new(2014, 1, 17).nth_day_of_month).to eq 3
      expect(Date.new(2014, 1, 18).nth_day_of_month).to eq 3
      expect(Date.new(2014, 1, 19).nth_day_of_month).to eq 3
      expect(Date.new(2014, 1, 20).nth_day_of_month).to eq 3
      expect(Date.new(2014, 1, 21).nth_day_of_month).to eq 3
      expect(Date.new(2014, 1, 22).nth_day_of_month).to eq 4
      expect(Date.new(2014, 1, 23).nth_day_of_month).to eq 4
      expect(Date.new(2014, 1, 24).nth_day_of_month).to eq 4
      expect(Date.new(2014, 1, 25).nth_day_of_month).to eq 4
      expect(Date.new(2014, 1, 26).nth_day_of_month).to eq 4
      expect(Date.new(2014, 1, 27).nth_day_of_month).to eq 4
      expect(Date.new(2014, 1, 28).nth_day_of_month).to eq 4
      expect(Date.new(2014, 1, 29).nth_day_of_month).to eq 5 # this is the 5th wednesday of the month
      expect(Date.new(2014, 1, 30).nth_day_of_month).to eq 5
      expect(Date.new(2014, 1, 31).nth_day_of_month).to eq 5

      expect(Date.new(2014, 2,  1).nth_day_of_month).to eq 1 # this is the first saturday of the month
      expect(Date.new(2014, 2,  2).nth_day_of_month).to eq 1
      expect(Date.new(2014, 2,  3).nth_day_of_month).to eq 1
      expect(Date.new(2014, 2,  4).nth_day_of_month).to eq 1
      expect(Date.new(2014, 2,  5).nth_day_of_month).to eq 1
      expect(Date.new(2014, 2,  6).nth_day_of_month).to eq 1
      expect(Date.new(2014, 2,  7).nth_day_of_month).to eq 1
      expect(Date.new(2014, 2,  8).nth_day_of_month).to eq 2 # this is the second saturday of the month
      expect(Date.new(2014, 2,  9).nth_day_of_month).to eq 2
      expect(Date.new(2014, 2, 10).nth_day_of_month).to eq 2
      expect(Date.new(2014, 2, 11).nth_day_of_month).to eq 2
      expect(Date.new(2014, 2, 12).nth_day_of_month).to eq 2
      expect(Date.new(2014, 2, 13).nth_day_of_month).to eq 2
      expect(Date.new(2014, 2, 14).nth_day_of_month).to eq 2
      expect(Date.new(2014, 2, 15).nth_day_of_month).to eq 3
      expect(Date.new(2014, 2, 16).nth_day_of_month).to eq 3
      expect(Date.new(2014, 2, 17).nth_day_of_month).to eq 3
      expect(Date.new(2014, 2, 18).nth_day_of_month).to eq 3
      expect(Date.new(2014, 2, 19).nth_day_of_month).to eq 3
      expect(Date.new(2014, 2, 20).nth_day_of_month).to eq 3
      expect(Date.new(2014, 2, 21).nth_day_of_month).to eq 3
      expect(Date.new(2014, 2, 22).nth_day_of_month).to eq 4
      expect(Date.new(2014, 2, 23).nth_day_of_month).to eq 4
      expect(Date.new(2014, 2, 24).nth_day_of_month).to eq 4
      expect(Date.new(2014, 2, 25).nth_day_of_month).to eq 4
      expect(Date.new(2014, 2, 26).nth_day_of_month).to eq 4
      expect(Date.new(2014, 2, 27).nth_day_of_month).to eq 4
      expect(Date.new(2014, 2, 28).nth_day_of_month).to eq 4 # this is the fourth friday of the month

      expect(Date.new(2014, 3,  1).nth_day_of_month).to eq 1
      expect(Date.new(2014, 3,  2).nth_day_of_month).to eq 1
      expect(Date.new(2014, 3,  3).nth_day_of_month).to eq 1
      expect(Date.new(2014, 3,  4).nth_day_of_month).to eq 1
      expect(Date.new(2014, 3,  5).nth_day_of_month).to eq 1
      expect(Date.new(2014, 3,  6).nth_day_of_month).to eq 1
      expect(Date.new(2014, 3,  7).nth_day_of_month).to eq 1
      expect(Date.new(2014, 3,  8).nth_day_of_month).to eq 2
      expect(Date.new(2014, 3,  9).nth_day_of_month).to eq 2
      expect(Date.new(2014, 3, 10).nth_day_of_month).to eq 2
      expect(Date.new(2014, 3, 11).nth_day_of_month).to eq 2
      expect(Date.new(2014, 3, 12).nth_day_of_month).to eq 2
      expect(Date.new(2014, 3, 13).nth_day_of_month).to eq 2
      expect(Date.new(2014, 3, 14).nth_day_of_month).to eq 2
      expect(Date.new(2014, 3, 15).nth_day_of_month).to eq 3
      expect(Date.new(2014, 3, 16).nth_day_of_month).to eq 3
      expect(Date.new(2014, 3, 17).nth_day_of_month).to eq 3
      expect(Date.new(2014, 3, 18).nth_day_of_month).to eq 3
      expect(Date.new(2014, 3, 19).nth_day_of_month).to eq 3
      expect(Date.new(2014, 3, 20).nth_day_of_month).to eq 3
      expect(Date.new(2014, 3, 21).nth_day_of_month).to eq 3
      expect(Date.new(2014, 3, 22).nth_day_of_month).to eq 4
      expect(Date.new(2014, 3, 23).nth_day_of_month).to eq 4
      expect(Date.new(2014, 3, 24).nth_day_of_month).to eq 4
      expect(Date.new(2014, 3, 25).nth_day_of_month).to eq 4
      expect(Date.new(2014, 3, 26).nth_day_of_month).to eq 4
      expect(Date.new(2014, 3, 27).nth_day_of_month).to eq 4
      expect(Date.new(2014, 3, 28).nth_day_of_month).to eq 4
      expect(Date.new(2014, 3, 29).nth_day_of_month).to eq 5
      expect(Date.new(2014, 3, 30).nth_day_of_month).to eq 5
      expect(Date.new(2014, 3, 31).nth_day_of_month).to eq 5
    end
  end

  describe :nth_last_day_of_month do
    it "should return the index of this week-day in the month" do
      expect(Date.new(2014, 1,  1).nth_last_day_of_month).to eq(-5) # this is the fifth last wednesday of the month
      expect(Date.new(2014, 1,  2).nth_last_day_of_month).to eq(-5)
      expect(Date.new(2014, 1,  3).nth_last_day_of_month).to eq(-5)
      expect(Date.new(2014, 1,  4).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 1,  5).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 1,  6).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 1,  7).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 1,  8).nth_last_day_of_month).to eq(-4) # this is the fourth last wednesday of the month
      expect(Date.new(2014, 1,  9).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 1, 10).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 1, 11).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 1, 12).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 1, 13).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 1, 14).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 1, 15).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 1, 16).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 1, 17).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 1, 18).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 1, 19).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 1, 20).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 1, 21).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 1, 22).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 1, 23).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 1, 24).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 1, 25).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 1, 26).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 1, 27).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 1, 28).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 1, 29).nth_last_day_of_month).to eq(-1) # this is the last wednesday of the month
      expect(Date.new(2014, 1, 30).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 1, 31).nth_last_day_of_month).to eq(-1)

      expect(Date.new(2014, 2,  1).nth_last_day_of_month).to eq(-4) # this is the fourth last saturday of the month
      expect(Date.new(2014, 2,  2).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 2,  3).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 2,  4).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 2,  5).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 2,  6).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 2,  7).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 2,  8).nth_last_day_of_month).to eq(-3) # this is the third last saturday of the month
      expect(Date.new(2014, 2,  9).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 2, 10).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 2, 11).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 2, 12).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 2, 13).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 2, 14).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 2, 15).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 2, 16).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 2, 17).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 2, 18).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 2, 19).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 2, 20).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 2, 21).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 2, 22).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 2, 23).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 2, 24).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 2, 25).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 2, 26).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 2, 27).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 2, 28).nth_last_day_of_month).to eq(-1) # this is the last friday of the month

      expect(Date.new(2014, 3,  1).nth_last_day_of_month).to eq(-5)
      expect(Date.new(2014, 3,  2).nth_last_day_of_month).to eq(-5)
      expect(Date.new(2014, 3,  3).nth_last_day_of_month).to eq(-5)
      expect(Date.new(2014, 3,  4).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 3,  5).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 3,  6).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 3,  7).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 3,  8).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 3,  9).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 3, 10).nth_last_day_of_month).to eq(-4)
      expect(Date.new(2014, 3, 11).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 3, 12).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 3, 13).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 3, 14).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 3, 15).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 3, 16).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 3, 17).nth_last_day_of_month).to eq(-3)
      expect(Date.new(2014, 3, 18).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 3, 19).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 3, 20).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 3, 21).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 3, 22).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 3, 23).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 3, 24).nth_last_day_of_month).to eq(-2)
      expect(Date.new(2014, 3, 25).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 3, 26).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 3, 27).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 3, 28).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 3, 29).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 3, 30).nth_last_day_of_month).to eq(-1)
      expect(Date.new(2014, 3, 31).nth_last_day_of_month).to eq(-1)
    end
  end

  describe :nth_day_of_month? do
    it "should return true or false depnding whether the date is the given nth day of the month" do
      d = Date.new(2014, 3,  1)
      expect(d.nth_day_of_month?( 1)).to be_true
      expect(d.nth_day_of_month?( 2)).to be_false
      expect(d.nth_day_of_month?( 3)).to be_false
      expect(d.nth_day_of_month?( 4)).to be_false
      expect(d.nth_day_of_month?( 5)).to be_false
      expect(d.nth_day_of_month?(-5)).to be_true
      expect(d.nth_day_of_month?(-4)).to be_false
      expect(d.nth_day_of_month?(-3)).to be_false
      expect(d.nth_day_of_month?(-2)).to be_false
      expect(d.nth_day_of_month?(-1)).to be_false

      d = Date.new(2014, 3,  15)
      expect(d.nth_day_of_month?( 1)).to be_false
      expect(d.nth_day_of_month?( 2)).to be_false
      expect(d.nth_day_of_month?( 3)).to be_true
      expect(d.nth_day_of_month?( 4)).to be_false
      expect(d.nth_day_of_month?( 5)).to be_false
      expect(d.nth_day_of_month?(-5)).to be_false
      expect(d.nth_day_of_month?(-4)).to be_false
      expect(d.nth_day_of_month?(-3)).to be_true
      expect(d.nth_day_of_month?(-2)).to be_false
      expect(d.nth_day_of_month?(-1)).to be_false

      d = Date.new(2014, 3,  31)
      expect(d.nth_day_of_month?( 1)).to be_false
      expect(d.nth_day_of_month?( 2)).to be_false
      expect(d.nth_day_of_month?( 3)).to be_false
      expect(d.nth_day_of_month?( 4)).to be_false
      expect(d.nth_day_of_month?( 5)).to be_true
      expect(d.nth_day_of_month?(-5)).to be_false
      expect(d.nth_day_of_month?(-4)).to be_false
      expect(d.nth_day_of_month?(-3)).to be_false
      expect(d.nth_day_of_month?(-2)).to be_false
      expect(d.nth_day_of_month?(-1)).to be_true
    end
  end
end
