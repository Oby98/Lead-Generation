class ChangeRequestColumn < ActiveRecord::Migration[6.1]
  def change
    change_column :requests, :bid, :string
  end
end
