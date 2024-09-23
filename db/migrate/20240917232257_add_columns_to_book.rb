class AddColumnsToBook < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :bibnum, :integer
    add_column :books, :title,  :string
    add_column :books, :isbn,   :string
    add_column :books, :publicationyear, :string
    add_column :books, :itemtype, :text
    add_column :books, :itemcollection, :text
    add_column :books, :floatingitem, :text
    add_column :books, :itemlocation, :text
    add_column :books, :reportdate, :datetime
    add_column :books, :itemcount, :integer
  end
end
