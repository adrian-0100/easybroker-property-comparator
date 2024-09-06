class CreateComparisons < ActiveRecord::Migration[6.0]
  def change
    create_table :comparisons do |t|
      t.decimal :price_difference, null: false, precision: 5, scale: 2
      t.decimal :size_difference, null: false, precision: 5, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
