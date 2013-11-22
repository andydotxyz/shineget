class AddBoughtToItem < ActiveRecord::Migration
  def change
    add_column :items, :bought, :boolean
  end
end
