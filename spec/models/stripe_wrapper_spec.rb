require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    token = Stripe::Token.create(
      :card => {
        number: '4242424242424242',
        cvc: 123,
        exp_month: Date.today.month,
        exp_year: Date.today.year + 2
      }
    ).id
  end

  let(:declined_token) do
    token = Stripe::Token.create(
      :card => {
        number: '4000000000000002',
        cvc: 123,
        exp_month: Date.today.month,
        exp_year: Date.today.year + 2
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe '.create' do
      context 'with valid card' do
        it 'makes a successful charge', :vcr do
          response = StripeWrapper::Charge.create(
            amount: 500, 
            card: valid_token, 
            description: 'A valid charge'
          )
          
          expect(response).to be_successful
        end
      end

      context 'with invalid card' do
        it 'does not make a charge', :vcr do
          response = StripeWrapper::Charge.create(
            amount: 500, 
            card: declined_token, 
            description: 'An invalid charge'
          )
          
          expect(response).not_to be_successful
        end

        it 'provides an error message', :vcr do
          response = StripeWrapper::Charge.create(
            amount: 500, 
            card: declined_token, 
            description: 'An invalid charge'
          )
          
          expect(response.error_message).to eq('Your card was declined.')
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      it 'creates a customer with a valid card', :vcr do
        bob = Fabricate(:user, email: 'bob@example.com')

        response = StripeWrapper::Customer.create(
          :user => bob,
          :card => valid_token
        )

        expect(response).to be_successful
      end

      it 'does not create a customer with an declined card', :vcr do
        bob = Fabricate(:user, email: 'bob@example.com')

        response = StripeWrapper::Customer.create(
          :user => bob,
          :card => declined_token
        )

        expect(response).not_to be_successful
      end

      it 'returns the error message for a declined card', :vcr do
        bob = Fabricate(:user, email: 'bob@example.com')

        response = StripeWrapper::Customer.create(
          :user => bob,
          :card => declined_token
        )

        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end
end
