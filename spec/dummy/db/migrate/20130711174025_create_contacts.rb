class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name

      t.timestamps
    end
  end
end
