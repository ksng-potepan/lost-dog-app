class AddColumnsightings < ActiveRecord::Migration[7.0]
  def change
    add_column :sightings, :user_id, :integer
  end
end
