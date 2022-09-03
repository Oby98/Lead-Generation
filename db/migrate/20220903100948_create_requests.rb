class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.string :category
      t.string :message
      t.integer :bid
      t.integer :price
      t.string :status

      t.timestamps
    end

    add_reference :requests, :lead, null: false, foreign_key: true, index: true
  end
end
