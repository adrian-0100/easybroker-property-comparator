# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_06_032603) do
  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.integer "user_id", null: false
    t.integer "comparison_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comparison_id"], name: "index_comments_on_comparison_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "comparisons", force: :cascade do |t|
    t.decimal "price_difference", precision: 5, scale: 2, null: false
    t.decimal "size_difference", precision: 5, scale: 2, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comparisons_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "title", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "formatted_price"
    t.decimal "size", precision: 10, scale: 2, null: false
    t.string "easybroker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["easybroker_id"], name: "index_properties_on_easybroker_id", unique: true
  end

  create_table "property_comparisons", force: :cascade do |t|
    t.integer "property_id", null: false
    t.integer "comparison_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comparison_id"], name: "index_property_comparisons_on_comparison_id"
    t.index ["property_id", "comparison_id"], name: "index_property_comparisons_on_property_id_and_comparison_id", unique: true
    t.index ["property_id"], name: "index_property_comparisons_on_property_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "encrypted_password"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "comparisons"
  add_foreign_key "comments", "users"
  add_foreign_key "comparisons", "users"
  add_foreign_key "property_comparisons", "comparisons"
  add_foreign_key "property_comparisons", "properties"
end
