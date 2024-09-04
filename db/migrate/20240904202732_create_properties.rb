class CreateProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :properties do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.decimal :size
      t.string :location
      t.string :property_type
      t.string :easybroker_id

      t.timestamps
    end
  end
end
