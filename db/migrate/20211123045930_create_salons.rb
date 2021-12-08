class CreateSalons < ActiveRecord::Migration[6.1]
  def change
    create_table :salons do |t|
      t.string :company_name
      t.string :gstin
      t.string :pan_number
      t.integer :user_id
      t.text :address
      t.datetime :start_time
      t.datetime :end_time
      t.integer :total_chairs

      t.timestamps
    end
  end
end
