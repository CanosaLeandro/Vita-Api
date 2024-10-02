class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :fromCoin, limit: 3, null: false
      t.string :toCoin, limit: 3, null: false
      t.decimal :amount, precision: 12, scale: 8, null: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
