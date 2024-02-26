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

ActiveRecord::Schema[7.1].define(version: 2024_02_25_222615) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chargeback_histories", force: :cascade do |t|
    t.integer "merchant_id"
    t.integer "user_id"
    t.datetime "chargeback_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_chargeback_histories_on_merchant_id"
    t.index ["user_id"], name: "index_chargeback_histories_on_user_id"
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.integer "merchant_id", null: false
    t.integer "user_id", null: false
    t.string "card_number", limit: 16, null: false
    t.datetime "date", null: false
    t.decimal "amount", precision: 7, scale: 2, default: "0.0", null: false
    t.integer "device_id"
    t.string "status", default: "approved", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_transaction_histories_on_merchant_id"
    t.index ["user_id"], name: "index_transaction_histories_on_user_id"
  end

end
