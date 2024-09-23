class CreateIsbns < ActiveRecord::Migration[7.2]
  def change
    create_table :isbns do |t|
      t.references :book, null: false, foreign_key: true
      t.string :isbn

      t.timestamps
    end
  end
end
