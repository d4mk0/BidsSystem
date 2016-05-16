class CreateStakes < ActiveRecord::Migration
  def change
    create_table :stakes do |t|
      t.integer :user_id, null: false, index: true
      t.integer :item_id, null: false, index: true
      t.integer :sum, null: false

      t.timestamps null: false
    end
  end
end
