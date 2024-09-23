class AddProcessedToBooks < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :processed, :boolean
  end
end
