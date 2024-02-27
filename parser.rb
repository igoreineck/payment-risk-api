# frozen_string_literal: true

require 'csv'
require 'net/http'
require 'json'

rows = []

CSV.foreach('transactional-sample.csv', headers: true, col_sep: ',') do |row|
  rows << {
    merchant_id: row['merchant_id'],
    user_id: row['user_id'],
    card_number: row['card_number'],
    transaction_date: row['transaction_date'],
    transaction_amount: row['transaction_amount'],
    device_id: row['device_id']
  }
end

uri = URI('http://localhost:3000/api/transactions')

Net::HTTP.start(uri.host, uri.port) do |http|
  rows.each do |row|
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = row.to_json

    response = http.request(request)

    puts response.body

    sleep 0.1
  end
end
