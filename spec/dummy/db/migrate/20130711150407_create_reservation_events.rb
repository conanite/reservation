class CreateReservationEvents < ActiveRecord::Migration
  def change
    create_table :reservation_events do |t|
      t.datetime :start
      t.datetime :finish
      t.string :title

      t.timestamps
    end
  end
end
