ActiveRecord::Schema.define do
  create_table "users", force: :cascade do |t|
    t.string :email
  end
end
