class ChangeUniqueToUsersColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :line_user_id, :string, unique: true
    change_column :users, :client_uuid, :uuid, unique: true
  end
end
