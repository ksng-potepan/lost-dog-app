class ChangeCloumnsNotnullAddAmbles < ActiveRecord::Migration[7.0]
  def change
    change_column :ambles, :municipalities, :string, null: false
  end
end
