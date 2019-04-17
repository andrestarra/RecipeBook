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

ActiveRecord::Schema.define(version: 2019_04_16_212816) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.string "calories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.string "type_menu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plates", force: :cascade do |t|
    t.string "name"
    t.string "main_ingredient"
    t.string "type_plate"
    t.float "price"
    t.string "comment"
    t.bigint "menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_plates_on_menu_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "source"
    t.string "location"
    t.float "total_minutes"
    t.bigint "plate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plate_id"], name: "index_recipes_on_plate_id"
  end

  create_table "steps", force: :cascade do |t|
    t.string "operation"
    t.float "expected_minutes"
    t.string "comment"
    t.bigint "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "uses", force: :cascade do |t|
    t.integer "quantity"
    t.string "measure"
    t.bigint "step_id"
    t.bigint "ingredient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_uses_on_ingredient_id"
    t.index ["step_id", "ingredient_id"], name: "index_uses_on_step_id_and_ingredient_id", unique: true
    t.index ["step_id"], name: "index_uses_on_step_id"
  end

  create_table "utensils", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "utilities", force: :cascade do |t|
    t.bigint "step_id"
    t.bigint "utensil_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["step_id", "utensil_id"], name: "index_utilities_on_step_id_and_utensil_id", unique: true
    t.index ["step_id"], name: "index_utilities_on_step_id"
    t.index ["utensil_id"], name: "index_utilities_on_utensil_id"
  end

  add_foreign_key "plates", "menus"
  add_foreign_key "recipes", "plates"
  add_foreign_key "steps", "recipes"
  add_foreign_key "uses", "ingredients"
  add_foreign_key "uses", "steps"
  add_foreign_key "utilities", "steps"
  add_foreign_key "utilities", "utensils"
end
