class AddEndsAtToItems < ActiveRecord::Migration
  def change
    add_column :items, :ends_at, :datetime, null: false, default: Time.now
  end
end
