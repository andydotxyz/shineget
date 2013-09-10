class AddImgurlAndTitleToItems < ActiveRecord::Migration
  def change
    add_column :items, :title, :string
    add_column :items, :imgurl, :string
  end
end
