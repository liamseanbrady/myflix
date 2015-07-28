require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context 'with blank input' do
      it 'redirects to the forgot password page' do
        post :create, email: ''

        expect(response).to redirect_to forgot_password_path
      end

      it 'shows an error message' do
        post :create, email: ''

        expect(flash[:danger]).to eq('Email cannot be blank')
      end

      it 'does send send an email' do
        post :create, email: ''

        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    context 'with existing email' do
      after { ActionMailer::Base.deliveries.clear }

      it 'redirects to the forgot password confirmation page' do
        alice = Fabricate(:user)

        post :create, email: alice.email

        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it 'sends an email to the email address provided' do
        alice = Fabricate(:user)

        post :create, email: alice.email

        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
   
    context 'with non-existing email'
      it 'redirects to the forgot password page' do
        post :create, email: 'alice@example.com'

        expect(response).to redirect_to forgot_password_path
      end

      it 'does not send an email' do
        post :create, email: 'alice@example.com'

        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it 'shows an error message' do
        post :create, email: 'alice@example.com'

        expect(flash[:danger]).to eq('There is no user with that email in the system')
      end
  end
end
