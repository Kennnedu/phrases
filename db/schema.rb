ActiveRecord::Schema.define(version: 20161119160000) do
  enable_extension "plpgsql"

  create_table "phrases", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
