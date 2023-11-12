class ChangePrefectureTypeToString < ActiveRecord::Migration[7.0]
  def change
    change_column :ambles, :prefecture, :string
  end
end
