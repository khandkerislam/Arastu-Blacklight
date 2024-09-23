class RemoveIsbnFromBooks < ActiveRecord::Migration[7.2]
  def change
    remove_column :books, :isbn, :string
  end
end
