class CreateSightings < ActiveRecord::Migration[7.0]
  def change
    create_table :sightings do |t|
      t.datetime :date, :null => false
      t.string :time
      t.text :area, :null => false
      t.text :situation

      t.timestamps
    end
  end
end
