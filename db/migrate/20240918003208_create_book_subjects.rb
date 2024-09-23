class CreateBookSubjects < ActiveRecord::Migration[7.2]
  def change
    create_table :book_subjects do |t|
      t.references :book, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
