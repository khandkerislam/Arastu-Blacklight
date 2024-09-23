class RemoveItemCollectionFromBooks < ActiveRecord::Migration[7.2]
  def change
    remove_column :books, :itemcollection
  end
end
