require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      it 'makes a successful charge', :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']

        token = Stripe::Token.create(
          :card => {
            number: '4242424242424242',
            cvc: 123,
            exp_month: Date.today.month,
            exp_year: Date.today.year + 2
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 500, 
          card: token, 
          description: 'A valid charge'
        )
        
        expect(response.amount).to eq(500)
        expect(response.currency).to eq('usd')
      end
    end
  end
end
