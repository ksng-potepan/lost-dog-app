class ChangeDataAgeToAmbles < ActiveRecord::Migration[7.0]
  def change
    change_column :ambles, :age, :string
  end
end
