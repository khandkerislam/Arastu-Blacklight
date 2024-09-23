class AddPublisherIdToBooks < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :publisher_id, :integer
    add_foreign_key :books, :publishers
  end
end
