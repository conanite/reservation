require "reservation/time_offset"

class Reservation::Event < ActiveRecord::Base
  extend Reservation::TimeOffset

  DAY_MAP = %w{ sun mon tue wed thu fri sat }
  has_many :reservations, :class_name => "Reservation::Reservation"
  attr_accessible :finish, :start, :title

  scope :since, lambda { |time| where("reservation_events.finish > ?", time) }
  scope :upto,  lambda { |time| where("reservation_events.start  < ?", time) }
  scope :reserved_for, lambda { |who|
    klass = who.class.base_class.name
    joins("join reservation_reservations rrx on reservation_events.id = rrx.event_id").where("rrx.subject_type = ? and rrx.subject_id = ?", klass, who.id)
  }

  def overlap? range_start, range_end
    (range_end > start) && (range_start < finish)
  end

  def matches? weekday_spec
    return true if weekday_spec.nil?
    return false if self.start.day != self.finish.day
    spec = weekday_spec[DAY_MAP[self.start.wday]]
    my_start = { :hour => self.start.hour, :min => self.start.min }
    my_finish = { :hour => self.finish.hour, :min => self.finish.min }
    spec.include? [my_start, my_finish]
  end

  def self.weekly_schedule_pattern pattern
    wdays = Hash.new { |h,k| h[k] = [] }

    pattern.each { |spec|
      wday   = spec["day"]
      start  = parse_time_offset spec["start"]
      finish = parse_time_offset spec["finish"]
      wdays[wday] << [start, finish]
    }

    wdays
  end

  def self.build_weekly title, from, upto, subjects, pattern
    this_day = Date.parse from
    max = Date.parse upto

    wdays = weekly_schedule_pattern pattern

    this_day.upto(max) { |date|
      wdays[DAY_MAP[date.wday]].each do |start_time, end_time|
        start_time = date.to_time.change start_time
        end_time = date.to_time.change end_time

        event = Reservation::Event.create! :title => title, :start => start_time, :finish => end_time
        subjects.each { |subject_data|
          role    = subject_data["role"]
          status  = subject_data["status"]
          subject = subject_data["subject"]
          event.reservations.create! :role => role, :reservation_status => status, :subject => subject
        }
      end
    }
  end

  def self.add_subject subject_data, select_options
    events = Reservation.events
    events = events.since(Date.parse(select_options["from"])) if select_options["from"]
    events = events.upto(Date.parse(select_options["upto"])) if select_options["upto"]
    events = events.reserved_for(select_options["context_subject"]) if select_options["context_subject"]
    wdays = weekly_schedule_pattern(select_options["pattern"]) if select_options["pattern"]

    events.each { |event|
      if event.matches? wdays
        role    = subject_data["role"]
        status  = subject_data["status"]
        subject = subject_data["subject"]
        event.reservations.create! :role => role, :reservation_status => status, :subject => subject
      end
    }
  end
end
