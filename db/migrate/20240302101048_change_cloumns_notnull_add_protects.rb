class ChangeCloumnsNotnullAddProtects < ActiveRecord::Migration[7.0]
  def change
    change_column :protects, :municipalities, :string, null: false
  end
end
