class AddAuthorIdToBooks < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :author_id, :integer
    add_foreign_key :books, :authors
  end
end
