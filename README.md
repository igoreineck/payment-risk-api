## Understanding the industry

1. Explain the money flow and the information flow in the acquirer market and the role of the main players.
	1. The payment flow in a transaction works like this: the cardholder (or the customer) gives the card information (it can be physically using a payment machine or using a web platform). The acquirer receives these information and send them to the entity that represents the card flag. This entity process the request and turn back these information to the bank. The bank approves or not the request and start the transaction back to finish the payment request.`

2. Explain the difference between acquirer, sub-acquirer and payment gateway and how the flow explained in question 1 changes for these players.
	1. **Acquirer**: An acquirer (also called a creditor) is a company that specializes in processing payments, meaning that it processes credit or debit card payments on behalf of a merchant. Through its network of accredited partners (or acquiring network), it enables a store to offer various payment conditions to its customers. When everything is in order and a purchase is authorized by the other players within the purchase flow, the acquirer is responsible for transferring the values (which the issuing bank receives from the customer) to the account of your store.
	2. **Sub-acquirer**: A sub-acquirer is a company that processes payments and transmits the generated data to the other players involved in the payment flow. It's role is similar to that of an acquirer, but it doesn't completely replace it due to the lack of autonomy to perform all the functionalities of an acquirer.
	3. **Payment gateway**: A gateway (also called payment gateway) is a system that transmits data from purchases at checkout to companies. As the first player in the flow, it's responsible for sending this information to acquirers, card brands and issuing banks then obtain a response about the continuation of the process or its cancellation. In other words, the gateway sends data and receives responses so that you know whether or not a particular purchase should be confirmed, showing whether the payment was approved or not.

> For the acquirer standpoint, in a high level they receive a purchase request from customers or stores and send some information for the banks, wait for bank approval and gives the answer back to the customer/store. The same logic might be applied for the sub-acquirer, the difference is that they aren't communicating with the bank directly.

> I'd say the gateway in this flow is nothing more than an API to process those checkout requests. If a payment machine is being used by a customer, the acquirer probably have a gateway to process these things. If the checkout is done using another web platform, the company also might have a gateway implemented before start communicating with the acquirer. 

3. Explain what chargebacks are, how they differ from cancellations and what is their connection with fraud in the acquiring world.
	1. A **chargeback** occurs when a cardholder disputes a transaction with their card issuer. In other words, the client (cardholder) request a payment reversal. A chargeback is requested in two scenarios, when a purchase doesn't meet all the expected requirements for a product, so the client is not satisfied at all. And in the second one, when a purchase was not recognized by the cardholder, which means a fraudulent purchase. The chargeback starts a process of dispute between the cardholder and the card issuer.
	2. A **cancellation** refers to the act of voiding a transaction before it is completed or finalized. And unlike chargebacks, cancellations tipically don't involve dispute resolution processes with card issuers, as they are usually handled directly between the buyer and the seller.

### Points to consider about the CSV file (and reflect)
1. The CSV file was generated from a query with **transaction_date** **DESC**. So the order should be considered
2. Purchases for the same **merchant_id**, **user_id** and **card_number** with different values in a small interval of time, might have a chance to be fraudulent (representing many tries in a row)
3. Requests without **device_id** might represent a device not registered (or not recognized). (Should they be denied?)
4. Purchases made at the same **device_id** for different merchants in a small interval of time, using the same **card_number** might be fraudulent. (Should they be denied?)  


## Running the project

**Copy env example**
```bash
cp development.env.example .env
```

**Setup** (make sure to have Docker Compose installed)
```bash
docker compose up -d
```

**Server startup** (listening on port 3000)
```bash
bundle exec rails server
```

**Running specs**
```bash
bundle exec rspec # it will run all tests
```

**Running the parser script, to test using sample data**
```bash
ruby parser.rb
```

## API structure

- POST '/api/transactions'

```JSON
// Example payload
{
  "merchant_id" : 1,
	"user_id" : 1,
	"card_number" : "434505******9116",
	"transaction_date" : "2020-11-31T23:16:32.812632",
	"transaction_amount" : 373,
	"device_id" : 285475
}

// Expected example success response
{
	"transaction_id": 299,
	"recommendation": "denied"
}
```

- GET '/api/transactions/:id'

```JSON
// Expected example success response -> id: 1
{
	"transaction_id": 1,
	"merchant_id" : 1,
	"user_id" : 1,
	"card_number" : "434505******9116",
	"transaction_date" : "2020-11-31T23:16:32.812632",
	"transaction_amount" : 373,
	"device_id" : 285475,
	"created_at": "2024-02-26T23:56:30-03:00",
	"updated_at": "2024-02-26T23:56:30-03:00",
}
```