class AddCurrentpriceToItems < ActiveRecord::Migration
  def change
    add_column :items, :currentprice, :decimal
  end
end
