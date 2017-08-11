# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170707003109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brains", force: :cascade do |t|
    t.integer "user_id"
    t.string  "learning_constants"
  end

  create_table "flashcards", force: :cascade do |t|
    t.text     "front_side"
    t.text     "back_side"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
    t.text     "data"
    t.string   "macro"
    t.float    "due_model"
    t.boolean  "still_learning"
    t.integer  "version"
  end

  create_table "flashcards_keywords", id: false, force: :cascade do |t|
    t.integer "flashcard_id"
    t.integer "keyword_id"
    t.index ["flashcard_id"], name: "index_flashcards_keywords_on_flashcard_id", using: :btree
    t.index ["keyword_id"], name: "index_flashcards_keywords_on_keyword_id", using: :btree
  end

  create_table "help_notifications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tip_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tips", force: :cascade do |t|
    t.string "text"
    t.string "description"
  end

  create_table "updates", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.integer  "flashcard_id"
    t.string   "user_response"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "pw_hash"
    t.integer  "brain_id"
    t.string   "email",                   default: "", null: false
    t.string   "encrypted_password",      default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "stripe_id"
    t.datetime "subscription_expiration"
    t.boolean  "cancel_at_end"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "no_email"
    t.string   "payment_token"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
