class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :author_name
      t.datetime :birth
      t.timestamps
    end
  end
end
