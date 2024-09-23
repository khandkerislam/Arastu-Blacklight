class AddCollectionIdToBooks < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :collection_id, :integer
    add_foreign_key :books, :collections
  end
end
