class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.string :title
      t.integer :price
      t.time :duration
      t.integer :salon_id

      t.timestamps
    end
  end
end
