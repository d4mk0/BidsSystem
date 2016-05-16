class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :start_sum, null: false
      t.integer :user_id, null: false, index: true
      t.string :name, null: false
      t.integer :min_step, null: false

      t.timestamps null: false
    end
  end
end
