class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :url
      t.string :name
      t.date :updated
      t.integer :user_id

      t.timestamps
    end
  end
end
