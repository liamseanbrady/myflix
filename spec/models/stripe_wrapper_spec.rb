require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      context 'with valid card' do
        it 'makes a successful charge', :vcr do
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
          
          expect(response).to be_successful
        end
      end

      context 'with invalid card' do
        it 'does not make a charge', :vcr do
          token = Stripe::Token.create(
            :card => {
              number: '4000000000000002',
              cvc: 123,
              exp_month: Date.today.month,
              exp_year: Date.today.year + 2
            }
          ).id

          response = StripeWrapper::Charge.create(
            amount: 500, 
            card: token, 
            description: 'An invalid charge'
          )
          
          expect(response).not_to be_successful
        end

        it 'provides an error message', :vcr do
          token = Stripe::Token.create(
            :card => {
              number: '4000000000000002',
              cvc: 123,
              exp_month: Date.today.month,
              exp_year: Date.today.year + 2
            }
          ).id

          response = StripeWrapper::Charge.create(
            amount: 500, 
            card: token, 
            description: 'An invalid charge'
          )
          
          expect(response.error_message).to eq('Your card was declined.')
        end
      end
    end
  end
end
