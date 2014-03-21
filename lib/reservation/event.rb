require "reservation/time_offset"

class Reservation::Event < ActiveRecord::Base
  extend Reservation::TimeOffset
  extend Reservation::EventFilter

  has_many :reservations, :class_name => "Reservation::Reservation", :inverse_of => :event

  scope :since, lambda { |time| where("reservation_events.finish > ?", time) }
  scope :upto,  lambda { |time| where("reservation_events.start  < ?", time) }
  scope :reserved_for, lambda { |who|
    klass = who.class.base_class.name
    join_name = "rrx_#{Time.now.to_i}#{rand(1000)}"
    joins("join reservation_reservations #{join_name} on reservation_events.id = #{join_name}.event_id").where("#{join_name}.subject_type = ? and #{join_name}.subject_id = ?", klass, who.id)
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

  def self.build_weekly title, from, upto, subjects, pattern
    schedule = Reservation::Schedule::Weekly.new pattern
    from = Date.parse from
    max = Date.parse upto
    events = schedule.generate from, max
    events.each { |e|
      e.title = title
        subjects.each { |subject_data|
          role    = subject_data["role"]
          status  = subject_data["status"]
          subject = subject_data["subject"]
          e.reservations.build :role => role, :reservation_status => status, :subject => subject
        }
      yield e if block_given?
    }
    events
  end

  def self.create_weekly title, from, upto, subjects, pattern
    build_weekly(title, from, upto, subjects, pattern) { |e| e.save! }
  end

  def self.remove_subject subject, filter_options
    filter_events(filter_options).each { |event|
      event.reservations.each { |r|
        if r.subject == subject
          r.destroy
        end
      }
    }
  end

  def self.add_subject subject_data, filter_options
    filter_events(filter_options).each { |event|
      role    = subject_data["role"]
      status  = subject_data["status"]
      subject = subject_data["subject"]
      event.reservations.create! :role => role, :reservation_status => status, :subject => subject
    }
  end
end
