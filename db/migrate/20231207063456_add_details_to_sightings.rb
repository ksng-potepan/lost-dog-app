class AddDetailsToSightings < ActiveRecord::Migration[7.0]
  def change
    add_column :sightings, :lat, :float
    add_column :sightings, :lng, :float
  end
end
