class RenameTrandferredColumnToProtect < ActiveRecord::Migration[7.0]
  def change
    rename_column :protects, :trandferred, :transferred
  end
end
