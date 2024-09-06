class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.string :title, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.string :formatted_price
      t.decimal :size, null: false, precision: 10, scale: 2
      t.string :easybroker_id, null: false

      t.timestamps
    end

    add_index :properties, :easybroker_id, unique: true
  end
end
