class CreateReservationTimeSlots < ActiveRecord::Migration
  def change
    create_table :reservation_time_slots do |t|
      t.datetime :start
      t.datetime :finish
      t.string :title

      t.timestamps
    end
  end
end
