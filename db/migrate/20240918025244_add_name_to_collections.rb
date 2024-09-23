class AddNameToCollections < ActiveRecord::Migration[7.2]
  def change
    add_column :collections, :name, :string
  end
end
