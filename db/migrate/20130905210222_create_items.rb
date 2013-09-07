class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :url
      t.text :notes
      t.decimal :price
      t.integer :list_id

      t.timestamps
    end
  end
end
