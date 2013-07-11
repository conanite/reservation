class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservation_time_slots do |t|
      t.datetime :start
      t.datetime :finish
      t.string :title

      t.timestamps
    end

    create_table :reservation_reservations do |t|
      t.integer :time_slot_id
      t.string :subject_type
      t.integer :subject_id
      t.string :reservation_status
      t.string :role

      t.timestamps
    end

  end
end
