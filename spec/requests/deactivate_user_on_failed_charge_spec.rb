require 'spec_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_172jjgAidogze5cBNXEEs0cH",
      "object" => "event",
      "api_version" => "2015-10-01",
      "created" => 1446476200,
      "data" => {
        "object" => {
          "id" => "ch_172jjgAidogze5cBAzmDOZuW",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1446476200,
          "currency" => "gbp",
          "customer" => "cus_7HIFhWd9YDK33r",
          "description" => "Payment will fail",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_172jjgAidogze5cBAzmDOZuW/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_172jhqAidogze5cByKLQUIoU",
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
            "customer" => "cus_7HIFhWd9YDK33r",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 11,
            "exp_year" => 2017,
            "fingerprint" => "kPx029GCzm9soiu0",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "statement_descriptor" => nil,
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 0,
      "request" => "req_7HIKuoqj8NxpxL",
      "type" => "charge.failed"
    }
  end

  it 'deactivates a user with the web hook data from Stripe when a charge fails', :vcr do
    alice = Fabricate(:user, customer_token: "cus_7HIFhWd9YDK33r")

    post '/stripe_events', event_data

    expect(alice.reload).not_to be_active
  end
end
