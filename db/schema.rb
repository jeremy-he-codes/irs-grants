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

ActiveRecord::Schema.define(version: 2022_02_02_164449) do

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type"
    t.integer "addressable_id"
    t.string "address_line1", null: false
    t.string "address_line2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.string "country", default: "US"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "awards", force: :cascade do |t|
    t.integer "filing_id"
    t.integer "recipient_id"
    t.bigint "amount", null: false
    t.string "grant_purpose"
    t.string "irc_section"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["filing_id"], name: "index_awards_on_filing_id"
    t.index ["irc_section"], name: "index_awards_on_irc_section"
    t.index ["recipient_id"], name: "index_awards_on_recipient_id"
  end

  create_table "filings", force: :cascade do |t|
    t.integer "filer_id"
    t.integer "tax_year", null: false
    t.datetime "period_begin_date"
    t.datetime "period_end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["filer_id", "tax_year"], name: "index_filings_on_filer_id_and_tax_year", unique: true
    t.index ["filer_id"], name: "index_filings_on_filer_id"
    t.index ["tax_year"], name: "index_filings_on_tax_year"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "ein"
    t.boolean "is_filer", default: false
    t.boolean "is_recipient", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ein"], name: "index_organizations_on_ein", unique: true
    t.index ["name"], name: "index_organizations_on_name"
  end

end
