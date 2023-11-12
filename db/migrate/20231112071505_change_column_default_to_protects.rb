class ChangeColumnDefaultToProtects < ActiveRecord::Migration[7.0]
  def change
    change_column_default :protects, :transferred, from: nil, to: false
  end
end
