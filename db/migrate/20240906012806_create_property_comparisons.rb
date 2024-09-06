class CreatePropertyComparisons < ActiveRecord::Migration[6.0]
  def change
    create_table :property_comparisons do |t|
      t.references :property, null: false, foreign_key: true
      t.references :comparison, null: false, foreign_key: true

      t.timestamps
    end

    add_index :property_comparisons, [ :property_id, :comparison_id ], unique: true
  end
end
