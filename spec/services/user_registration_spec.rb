require 'spec_helper'

describe UserRegistration do
  describe '#register' do
    context 'valid personal info and valid card' do
      let(:charge) { double('charge', successful?: true) }
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge) 
        ActionMailer::Base.deliveries.clear
      end

      it 'creates a user' do
        UserRegistration.new(Fabricate.build(:user)).register('stripe-token', nil)
          
        expect(User.count).to eq(1)
      end

      it 'makes the user follow the inviter' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')

        UserRegistration.new(Fabricate.build(:user, email: 'bob@example.com')).register('stripe-token', invitation.token)

        bob = User.find_by(email: 'bob@example.com')
        expect(bob.follows?(alice)).to be_truthy
      end

      it 'makes the inviter follow the user' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')

        UserRegistration.new(Fabricate.build(:user, email: 'bob@example.com')).register('stripe-token', invitation.token)

        bob = User.find_by(email: 'bob@example.com')
        expect(alice.follows?(bob)).to be_truthy
      end

      it 'expires the invitation upon acceptance' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')

        UserRegistration.new(Fabricate.build(:user, email: 'bob@example.com')).register('stripe-token', invitation.token)

        expect(invitation.reload.token).to be_nil
      end

      it 'sends out email to the user with valid inputs' do
        UserRegistration.new(Fabricate.build(:user)).register('stripe-token', nil)

        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out email containing the user's name with valid inputs" do
        UserRegistration.new(Fabricate.build(:user, full_name: 'Alice')).register('stripe-token', nil)

        expect(ActionMailer::Base.deliveries.last.body).to include("Alice")
      end
    end

    context 'with valid personal info and declined card' do
      let(:charge) { double('charge', successful?: false, error_message: 'Your card was declined') }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it 'does not create a new user record' do
        UserRegistration.new(Fabricate.build(:user)).register('stripe-token', nil)

        expect(User.count).to eq(0)
      end
    end

    context 'with invalid personal info' do
      before do
        StripeWrapper::Charge.should_not_receive(:create)
        ActionMailer::Base.deliveries.clear
      end

      it 'does not create a user' do
        UserRegistration.new(Fabricate.build(:user, email: '')).register('stripe-token', nil)

        expect(User.count).to eq(0)
      end

      it 'does not charge the card' do
        UserRegistration.new(Fabricate.build(:user, email: '')).register('stripe-token', nil)
      end

      it 'does not send out email with invalid inputs' do
        UserRegistration.new(Fabricate.build(:user, email: '')).register('stripe-token', nil)

        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
