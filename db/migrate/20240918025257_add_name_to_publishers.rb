class AddNameToPublishers < ActiveRecord::Migration[7.2]
  def change
    add_column :publishers, :name, :string
  end
end
