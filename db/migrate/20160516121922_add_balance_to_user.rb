class AddBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_balance, :integer, null: false, default: 0
    add_column :users, :frozen_balance, :integer, null: false, default: 0
  end
end
