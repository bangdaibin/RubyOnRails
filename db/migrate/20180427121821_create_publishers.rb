class CreatePublishers < ActiveRecord::Migration[5.1]
  def change
    create_table :publishers do |t|
      t.string :publisher_name
      t.string :address
      t.timestamps
    end
  end
end
