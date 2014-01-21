# Reservation

A gem for managing reservations. Provides the notion of "Event", which is basically an interval in time, and a
"Reservation", which is a many-to-many association model between Event and your objects.

There is no privileged event "owner", all associations are considered equivalent.

This gem uses ActiveRecord to store events and reservations

## Installation

Add this line to your application's Gemfile:

    gem 'reservation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reservation

## Usage

First of all migrate your schema so you have the necessary tables -

    rails g reservation:migration

Objects associated with an event are called "subjects"; each event has many subjects, via an association
model called Reservation::Reservation. The simplest way to create a bunch of events is to use Event#create_weekly.
This will create a set of events, with the given subjects, within the given constraints, repeating weekly.

    subjects = [ { "role" => "owner", "subject" => matt, "status" => "confirmed" },
                 { "role" => "helpr", "subject" => bill, "status" => "tentative" },
                 { "role" => "place", "subject" => here, "status" => "tentative" }
               ]

    patterns = [ { "day" => "wed", "start" => "0930", "finish" => "1030"},
                 { "day" => "wed", "start" => "18",   "finish" => "20"  },
                 { "day" => "tue", "start" => "7",    "finish" => "830" } ]

    Reservation::Event.create_weekly "the_title", "2013-09-03", "2013-10-13", subjects, pattern

A 'pattern' may contain an 'nth_of_month' key, in which case the gem will generate events only on days which
are the given nth day of the month (for example, "2nd wednesday of each month", "last saturday of the month").

You can use Reservation::Event#build_weekly instead in order to instantiate the object graph without
persisting it.

## History

v0.0.5 Add "nth day of month" feature

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## license

MIT License
