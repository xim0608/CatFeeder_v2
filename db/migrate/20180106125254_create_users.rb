class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :line_user_id
      t.uuid :client_uuid
    end
  end
end
