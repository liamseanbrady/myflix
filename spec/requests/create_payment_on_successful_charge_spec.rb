require 'spec_helper'

describe 'Create payment on successful charge' do
  let(:event_data) do
    {
      "id" => "evt_16yQi6Aidogze5cBJlCoyuVL",
      "object" => "event",
      "api_version" => "2015-10-01",
      "created" => 1445449754,
      "data" => {
        "object" => {
          "id" => "ch_16yQi5Aidogze5cB6k8igS2L",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => "txn_16yQi6Aidogze5cBnuH5qeoE",
          "captured" => true,
          "created" => 1445449753,
          "currency" => "usd",
          "customer" => "cus_7CqOEJKriOKoCh",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {
          },
          "invoice" => "in_16yQi5Aidogze5cBZW82wnd0",
          "livemode" => false,
          "metadata" => {
          },
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [

            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_16yQi5Aidogze5cB6k8igS2L/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_16yQi2Aidogze5cBOZNIOwed",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_7CqOEJKriOKoCh",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 10,
            "exp_year" => 2016,
            "fingerprint" => "S6osJGfIq46nTluH",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "statement_descriptor" => nil,
          "status" => "succeeded"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_7CqOmLo75BhOiz",
      "type" => "charge.succeeded"
    }
  end

  it 'creates a payment with the webhook from stripe for charge succeeded', :vcr do
    post '/stripe_events', event_data

    expect(Payment.count).to eq(1)
  end

  it 'creates a payment associated with the correct user', :vcr do
    alice = Fabricate(:user, customer_token: 'cus_7CqOEJKriOKoCh')

    post '/stripe_events', event_data

    expect(Payment.first.user).to eq(alice)
  end

  it 'creates a payment with the correct amount', :vcr do
    post '/stripe_events', event_data

    expect(Payment.first.amount).to eq(999)
  end

  it 'creates a payment with the correct charge reference', :vcr do
    post '/stripe_events', event_data

    expect(Payment.first.reference_id).to eq('ch_16yQi5Aidogze5cB6k8igS2L')
  end
end
