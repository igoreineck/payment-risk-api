class CreateTransactionHistory < ActiveRecord::Migration[7.1]
  def change
    create_table :transaction_histories, id: :uuid do |t|
      t.integer :transaction_id, null: false, index: { unique: true }
      t.integer :merchant_id, null: false, index: true
      t.integer :user_id, null: false, index: true
      t.string :card_number, null: false, limit: 16
      t.datetime :date, null: false
      t.decimal :amount, null: false, default: 0, precision: 7, scale: 2
      t.integer :device_id
      t.string :status, null: false

      t.timestamps
    end
  end
end
