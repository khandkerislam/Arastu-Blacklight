class ChangeYearToIntegerBooks < ActiveRecord::Migration[7.2]
  def change
    change_column :books, :publicationyear, 'integer USING publicationyear::integer'
  end
end
