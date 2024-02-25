class CreateChargebackHistory < ActiveRecord::Migration[7.1]
  def change
    create_table :chargeback_histories do |t|
      t.integer :merchant_id, index: true
      t.integer :user_id, index: true
      t.datetime :chargeback_datetime

      t.timestamps
    end
  end
end
