class CreateImagesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :image
      t.references :user

      t.timestamp
    end
  end
end
