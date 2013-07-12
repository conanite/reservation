require 'spec_helper'

describe Reservation::Event do
  before { Time.zone = "Europe/Paris" }
  let(:matt) { Person.create! :name => "matt" }
  let(:here) { Place.create! :name => "here" }
  let(:bill) { Person.create! :name => "bill" }

  def the_reservations subject=nil
      if subject
        Reservation::Reservation.where(:subject_type => subject.class.base_class.name, :subject_id => subject.id)
      else
        Reservation::Reservation.all
      end.map { |r| "#{r.event.title} #{r.subject.name} #{r.event.start.prettyd} #{r.event.finish.prettyd} #{r.reservation_status}"}.join("\n")
  end

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

  describe "#since and #upto scopes" do
    before {
      @r1 = Reservation::Event.create! :start => time("1999-12-15T16:00:00"), :finish => time("1999-12-15T22:00:00"), :title => "r1"
      @r2 = Reservation::Event.create! :start => time("1999-12-15T08:00:00"), :finish => time("1999-12-15T22:00:00"), :title => "r2"
      @r3 = Reservation::Event.create! :start => time("1999-12-14T00:00:00"), :finish => time("1999-12-25T00:00:00"), :title => "r3"
      @r4 = Reservation::Event.create! :start => time("1999-12-01T18:00:00"), :finish => time("1999-12-01T22:00:00"), :title => "r4"
      @r5 = Reservation::Event.create! :start => time("1999-12-01T00:00:00"), :finish => time("1999-12-15T19:00:00"), :title => "r5"
      @r6 = Reservation::Event.create! :start => time("1999-12-15T17:00:00"), :finish => time("1999-12-16T07:00:00"), :title => "r6"

      #r1                                     ======
      #r2                             ==============
      #r3                 ==========================================
      #r4    =====
      #r5 =======================================
      #r6                                      ============
    }

    def since t
      Reservation::Event.since(time(t)).order(:id).map(&:title)
    end

    def upto t
      Reservation::Event.upto(time(t)).order(:id).map(&:title)
    end

    it "should find all events since 1999-01-01 00:00" do
      since("1999-01-01T00:00:00").should == %w{ r1 r2 r3 r4 r5 r6 }
    end

    it "should find 6 events since 1999-12-01 16:00" do
      since("1999-12-01T16:00:00").should == %w{ r1 r2 r3 r4 r5 r6 }
    end

    it "should find 5 events since 1999-12-15 16:00" do
      since("1999-12-15T16:00:00").should == %w{ r1 r2 r3 r5 r6 }
    end

    it "should find 5 events since 1999-12-15 18:00" do
      since("1999-12-15T18:00:00").should == %w{ r1 r2 r3 r5 r6 }
    end

    it "should find 4 events since 1999-12-15 20:00" do
      since("1999-12-15T20:00:00").should == %w{ r1 r2 r3 r6 }
    end

    it "should find 2 events since 1999-12-15 23:00" do
      since("1999-12-15T23:00:00").should == %w{ r3 r6 }
    end

    it "should find 1 event since 1999-12-16 08:00" do
      since("1999-12-16T08:00:00").should == %w{ r3 }
    end

    it "should find no event since 1999-12-26 08:00" do
      since("1999-12-26T08:00:00").should == []
    end

    it "should find all events upto 1999-12-26 00:00" do
      upto("1999-12-26T00:00:00").should == %w{ r1 r2 r3 r4 r5 r6 }
    end

    it "should find 6 events upto 1999-12-24 12:00" do
      upto("1999-12-24T12:00:00").should == %w{ r1 r2 r3 r4 r5 r6 }
    end

    it "should find 5 events upto 1999-12-15 17:00" do
      upto("1999-12-15T17:00:00").should == %w{ r1 r2 r3 r4 r5 }
    end

    it "should find 4 events upto 1999-12-15 16:00" do
      upto("1999-12-15T16:00:00").should == %w{ r2 r3 r4 r5 }
    end

    it "should find 3 events upto 1999-12-15 08:00" do
      upto("1999-12-15T08:00:00").should == %w{ r3 r4 r5 }
    end

    it "should find 2 events upto 1999-12-07 12:00" do
      upto("1999-12-07T12:00:00").should == %w{ r4 r5 }
    end

    it "should find 1 event upto 1999-12-01 18:00" do
      upto("1999-12-01T18:00:00").should == %w{ r5 }
    end

    it "should find no event upto 1999-11-30 23:00" do
      upto("1999-11-30T23:00:00").should == []
    end
  end

  describe :reserved_for do
    before {
      @r1 = Reservation::Event.create! :start => time("1999-12-15T16:00:00"), :finish => time("1999-12-15T22:00:00"), :title => "r1"
      @r2 = Reservation::Event.create! :start => time("1999-12-15T08:00:00"), :finish => time("1999-12-15T22:00:00"), :title => "r2"
      @r3 = Reservation::Event.create! :start => time("1999-12-14T00:00:00"), :finish => time("1999-12-25T00:00:00"), :title => "r3"
      @r4 = Reservation::Event.create! :start => time("1999-12-01T18:00:00"), :finish => time("1999-12-01T22:00:00"), :title => "r4"
      @r5 = Reservation::Event.create! :start => time("1999-12-01T00:00:00"), :finish => time("1999-12-15T19:00:00"), :title => "r5"
      @r6 = Reservation::Event.create! :start => time("1999-12-15T17:00:00"), :finish => time("1999-12-16T07:00:00"), :title => "r6"

      @cafe = Place.create! :name => "Cafe"
      @book = Thing.create! :name => "Ulysses"
      @matt = Person.create! :name => "Matt"
      @appl = Organisation.create! :name => "APPL"

      Reservation::Reservation.create! :event => @r1, :subject => @cafe
      Reservation::Reservation.create! :event => @r1, :subject => @matt

      Reservation::Reservation.create! :event => @r2, :subject => @cafe
      Reservation::Reservation.create! :event => @r2, :subject => @book

      Reservation::Reservation.create! :event => @r3, :subject => @book
      Reservation::Reservation.create! :event => @r3, :subject => @matt

      Reservation::Reservation.create! :event => @r4, :subject => @matt
      Reservation::Reservation.create! :event => @r4, :subject => @appl

      Reservation::Reservation.create! :event => @r5, :subject => @appl
      Reservation::Reservation.create! :event => @r5, :subject => @cafe

      Reservation::Reservation.create! :event => @r6, :subject => @appl
      Reservation::Reservation.create! :event => @r6, :subject => @book
    }

    def events who
      Reservation::Event.reserved_for(who).order(:id)
    end

    it "should find events for Cafe" do
      ee = events(@cafe)
      ee.should == [@r1, @r2, @r5]
      ee[0].reservations.map(&:subject).map(&:name).should == %w{ Cafe Matt }
      ee[1].reservations.map(&:subject).map(&:name).should == %w{ Cafe Ulysses }
      ee[2].reservations.map(&:subject).map(&:name).should == %w{ APPL Cafe }
    end

    it "should find events for Ulysses" do
      ee = events(@book)
      ee.should == [@r2, @r3, @r6]
      ee[0].reservations.map(&:subject).map(&:name).should == %w{ Cafe Ulysses }
      ee[1].reservations.map(&:subject).map(&:name).should == %w{ Ulysses Matt }
      ee[2].reservations.map(&:subject).map(&:name).should == %w{ APPL Ulysses }
    end

    it "should find events for Matt" do
      ee = events(@matt)
      ee.should == [@r1, @r3, @r4]
      ee[0].reservations.map(&:subject).map(&:name).should == %w{ Cafe Matt }
      ee[1].reservations.map(&:subject).map(&:name).should == %w{ Ulysses Matt }
      ee[2].reservations.map(&:subject).map(&:name).should == %w{ Matt APPL }
    end

    it "should find events for APPL" do
      ee = events(@appl)
      ee.should == [@r4, @r5, @r6]
      ee[0].reservations.map(&:subject).map(&:name).should == %w{ Matt APPL }
      ee[1].reservations.map(&:subject).map(&:name).should == %w{ APPL Cafe }
      ee[2].reservations.map(&:subject).map(&:name).should == %w{ APPL Ulysses }
    end

    it "should find events for Ulysses and AAPL" do
      ee = Reservation::Event.reserved_for(@book).reserved_for(@appl).order(:id)
      ee.should == [@r6]
    end
  end

  describe :create_weekly do
    it "should build a simple event for a single subject" do
      subjects = [{ "role" => "owner", "subject" => matt, "status" => "confirmed" } ]
      pattern = [ { "day" => "mon", "start" => "0930", "finish" => "1030"} ]
      Reservation::Event.create_weekly "floss teeth", "2013-09-03", "2013-10-13", subjects, pattern
      the_reservations.should == "floss teeth matt Mon,20130909T0930 Mon,20130909T1030 confirmed
floss teeth matt Mon,20130916T0930 Mon,20130916T1030 confirmed
floss teeth matt Mon,20130923T0930 Mon,20130923T1030 confirmed
floss teeth matt Mon,20130930T0930 Mon,20130930T1030 confirmed
floss teeth matt Mon,20131007T0930 Mon,20131007T1030 confirmed"
    end

    it "should build multiple events for multiple subjects" do
      subjects = [{ "role" => "owner", "subject" => matt, "status" => "confirmed" }, { "role" => "place", "subject" => here, "status" => "tentative" }]
      pattern = [ { "day" => "wed", "start" => "0930", "finish" => "1030"}, { "day" => "wed", "start" => "18", "finish" => "20"}, { "day" => "tue", "start" => "7", "finish" => "830"} ]
      Reservation::Event.create_weekly "the_title", "2013-09-03", "2013-09-30", subjects, pattern
      the_reservations.should == "the_title matt Tue,20130903T0700 Tue,20130903T0830 confirmed
the_title here Tue,20130903T0700 Tue,20130903T0830 tentative
the_title matt Wed,20130904T0930 Wed,20130904T1030 confirmed
the_title here Wed,20130904T0930 Wed,20130904T1030 tentative
the_title matt Wed,20130904T1800 Wed,20130904T2000 confirmed
the_title here Wed,20130904T1800 Wed,20130904T2000 tentative
the_title matt Tue,20130910T0700 Tue,20130910T0830 confirmed
the_title here Tue,20130910T0700 Tue,20130910T0830 tentative
the_title matt Wed,20130911T0930 Wed,20130911T1030 confirmed
the_title here Wed,20130911T0930 Wed,20130911T1030 tentative
the_title matt Wed,20130911T1800 Wed,20130911T2000 confirmed
the_title here Wed,20130911T1800 Wed,20130911T2000 tentative
the_title matt Tue,20130917T0700 Tue,20130917T0830 confirmed
the_title here Tue,20130917T0700 Tue,20130917T0830 tentative
the_title matt Wed,20130918T0930 Wed,20130918T1030 confirmed
the_title here Wed,20130918T0930 Wed,20130918T1030 tentative
the_title matt Wed,20130918T1800 Wed,20130918T2000 confirmed
the_title here Wed,20130918T1800 Wed,20130918T2000 tentative
the_title matt Tue,20130924T0700 Tue,20130924T0830 confirmed
the_title here Tue,20130924T0700 Tue,20130924T0830 tentative
the_title matt Wed,20130925T0930 Wed,20130925T1030 confirmed
the_title here Wed,20130925T0930 Wed,20130925T1030 tentative
the_title matt Wed,20130925T1800 Wed,20130925T2000 confirmed
the_title here Wed,20130925T1800 Wed,20130925T2000 tentative"
    end
  end

  describe :add_subject do
    it "should add a subject within time constraints" do
      subjects = [{ "role" => "owner", "subject" => matt, "status" => "confirmed" } ]
      pattern = [ { "day" => "mon", "start" => "0930", "finish" => "1030"} ]
      Reservation::Event.create_weekly "my_title", "2013-09-03", "2013-10-13", subjects, pattern
      Reservation::Event.add_subject({ "role" => "student", "status" => "tentative", "subject" => bill}, { "from" => "2013-09-01", "upto" => "2013-09-24", "context" => matt })
      the_reservations.should == "my_title matt Mon,20130909T0930 Mon,20130909T1030 confirmed
my_title matt Mon,20130916T0930 Mon,20130916T1030 confirmed
my_title matt Mon,20130923T0930 Mon,20130923T1030 confirmed
my_title matt Mon,20130930T0930 Mon,20130930T1030 confirmed
my_title matt Mon,20131007T0930 Mon,20131007T1030 confirmed
my_title bill Mon,20130909T0930 Mon,20130909T1030 tentative
my_title bill Mon,20130916T0930 Mon,20130916T1030 tentative
my_title bill Mon,20130923T0930 Mon,20130923T1030 tentative"
    end

    it "should add a subject within schedule contraints" do
      subjects = [ { "role" => "owner", "subject" => matt, "status" => "confirmed" },
                   { "role" => "place", "subject" => here, "status" => "tentative" } ]

      pattern = [ { "day" => "wed", "start" => "0930", "finish" => "1030" },
                  { "day" => "wed", "start" => "18",   "finish" => "20"   },
                  { "day" => "tue", "start" => "7",    "finish" => "830"  } ]

      Reservation::Event.create_weekly "the_title", "2013-09-03", "2013-10-13", subjects, pattern

      add_schedule = [ { "day" => "wed", "start" => "18", "finish" => "20"} ]
      Reservation::Event.add_subject({ "role" => "student", "status" => "tentative", "subject" => bill}, { "from" => "2013-09-17", "upto" => "2013-10-02", "schedule" => add_schedule })
      the_reservations(bill).should == "the_title bill Wed,20130918T1800 Wed,20130918T2000 tentative
the_title bill Wed,20130925T1800 Wed,20130925T2000 tentative
the_title bill Wed,20131002T1800 Wed,20131002T2000 tentative"
    end
  end

  describe :remove_subject do
    it "should remove a subject within time constraints" do
      subjects = [{ "role" => "owner", "subject" => matt, "status" => "confirmed" }, { "role" => "owner", "subject" => bill, "status" => "confirmed" } ]
      pattern = [ { "day" => "mon", "start" => "0930", "finish" => "1030"} ]
      Reservation::Event.create_weekly "my_title", "2013-09-03", "2013-10-13", subjects, pattern
      Reservation::Event.remove_subject(bill, { "from" => "2013-09-15", "upto" => "2013-09-24", "context" => matt })
      the_reservations.should == "my_title matt Mon,20130909T0930 Mon,20130909T1030 confirmed
my_title bill Mon,20130909T0930 Mon,20130909T1030 confirmed
my_title matt Mon,20130916T0930 Mon,20130916T1030 confirmed
my_title matt Mon,20130923T0930 Mon,20130923T1030 confirmed
my_title matt Mon,20130930T0930 Mon,20130930T1030 confirmed
my_title bill Mon,20130930T0930 Mon,20130930T1030 confirmed
my_title matt Mon,20131007T0930 Mon,20131007T1030 confirmed
my_title bill Mon,20131007T0930 Mon,20131007T1030 confirmed"
    end

    it "should remove a subject within schedule contraints" do
      subjects = [ { "role" => "owner", "subject" => matt, "status" => "confirmed" },
                   { "role" => "helpr", "subject" => bill, "status" => "tentative" },
                   { "role" => "place", "subject" => here, "status" => "tentative" }
                 ]

      pattern = [ { "day" => "wed", "start" => "0930", "finish" => "1030"},
                  { "day" => "wed", "start" => "18",   "finish" => "20"  },
                  { "day" => "tue", "start" => "7",    "finish" => "830" } ]

      Reservation::Event.create_weekly "the_title", "2013-09-03", "2013-10-13", subjects, pattern

      remove_schedule = [ { "day" => "wed", "start" => "18", "finish" => "20"}, { "day" => "wed", "start" => "930", "finish" => "1030"} ]
      Reservation::Event.remove_subject(bill, { "from" => "2013-09-17", "upto" => "2013-10-02", "schedule" => remove_schedule })

      the_reservations(bill).should == "
the_title bill Tue,20130903T0700 Tue,20130903T0830 tentative
the_title bill Wed,20130904T0930 Wed,20130904T1030 tentative
the_title bill Wed,20130904T1800 Wed,20130904T2000 tentative
the_title bill Tue,20130910T0700 Tue,20130910T0830 tentative
the_title bill Wed,20130911T0930 Wed,20130911T1030 tentative
the_title bill Wed,20130911T1800 Wed,20130911T2000 tentative
the_title bill Tue,20130917T0700 Tue,20130917T0830 tentative
the_title bill Tue,20130924T0700 Tue,20130924T0830 tentative
the_title bill Tue,20131001T0700 Tue,20131001T0830 tentative
the_title bill Tue,20131008T0700 Tue,20131008T0830 tentative
the_title bill Wed,20131009T0930 Wed,20131009T1030 tentative
the_title bill Wed,20131009T1800 Wed,20131009T2000 tentative".strip
    end
  end
end
