class AddDefaultToProcessedInBooks < ActiveRecord::Migration[7.2]
  def change
    change_column_default :books, :processed, false
  end
end
