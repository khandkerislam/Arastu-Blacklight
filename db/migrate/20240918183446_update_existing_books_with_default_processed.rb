class UpdateExistingBooksWithDefaultProcessed < ActiveRecord::Migration[7.2]
  def change
    Book.where(processed: nil).update_all(processed: false)
  end
end
