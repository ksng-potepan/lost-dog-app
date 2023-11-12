class CreateProtects < ActiveRecord::Migration[7.0]
  def change
    create_table :protects do |t|
      t.string :name
      t.string :breed
      t.string :size
      t.string :gender
      t.string :color
      t.string :age
      t.text :features
      t.boolean :tag
      t.boolean :chip
      t.datetime :date, null: false
      t.string :time
      t.string :prefecture, null: false
      t.string :municipalities
      t.text :area
      t.text :situation, null: false
      t.text :notification
      t.boolean :trandferred
      t.text :location
      t.integer :user_id

      t.timestamps
    end
  end
end
