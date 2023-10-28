class AddUserIdToAmbles < ActiveRecord::Migration[7.0]
  def change
    add_column :ambles, :user_id, :integer
  end
end
