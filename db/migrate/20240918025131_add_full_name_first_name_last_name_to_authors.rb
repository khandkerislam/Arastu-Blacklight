class AddFullNameFirstNameLastNameToAuthors < ActiveRecord::Migration[7.2]
  def change
    add_column :authors, :full_name, :string
    add_column :authors, :first_name, :string
    add_column :authors, :last_name, :string
  end
end
