class CreateAdress < ActiveRecord::Migration[7.0]
  def change
    create_table :adresses do |t|
        t.integer :adress_area, null: false, default: 0
      t.timestamps
    end
  end
end
