class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :service_id
      t.datetime :time_slot_taken

      t.timestamps
    end
  end
end
