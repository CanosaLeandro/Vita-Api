class AddBalanceToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :balance, :decimal, precision: 12, scale: 8, default: 0
  end
end
