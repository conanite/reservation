ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'reservation'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = 'random'

  config.before(:each) {
    models = [Thing, Place, Reservation::Event, Reservation::Reservation]
    models.each do |model|
      ActiveRecord::Base.connection.execute "DELETE FROM #{model.table_name}"
    end
  }
end


module Helper
  def date d
    Date.parse d
  end

  def time t
    Time.parse t
  end
end

RSpec::Core::ExampleGroup.send :include, Helper

File.delete File.dirname(__FILE__) + '/dummy/db/test.sqlite3'
ActiveRecord::Base.establish_connection
ActiveRecord::Base.connection
ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load(File.dirname(__FILE__) + '/dummy/db/schema.rb')
end

class Time
  def pretty
    self.strftime("%Y%m%dT%H%M")
  end
end

