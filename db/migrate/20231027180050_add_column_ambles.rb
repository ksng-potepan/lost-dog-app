class AddColumnAmbles < ActiveRecord::Migration[7.0]
  def change
    add_column :ambles, :time, :string
  end
end
