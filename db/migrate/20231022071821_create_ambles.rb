class CreateAmbles < ActiveRecord::Migration[7.0]
  def change
    create_table :ambles do |t|
      t.string "name", null: false
      t.string "breed"
      t.string "size"
      t.string "gender"
      t.string "color"
      t.integer "age"
      t.text "features"
      t.boolean "tag"
      t.boolean "chip"
      t.datetime "date", null: false
      t.integer "prefecture", null: false
      t.string "municipalities"
      t.string "area"
      t.text "situation"
      t.text "notification"

      t.timestamps
    end
  end
end
