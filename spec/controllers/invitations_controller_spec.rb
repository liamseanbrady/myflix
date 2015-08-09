require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    it 'sets @invitation to a new invitation' do
      set_current_user

      get :new

      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end
    
    context 'with valid input' do
      after { ActionMailer::Base.deliveries.clear }

      it 'redirects to the invitation new page' do
        set_current_user

        post :create, invitation: { recipient_name: 'Coco', recipient_email: 'coco@example.com', message: 'Hey, join me on MyFlix!' }

        expect(response).to redirect_to new_invitation_path
        
      end

      it 'creates an invitation' do
        set_current_user

        post :create, invitation: { recipient_name: 'Coco', recipient_email: 'coco@example.com', message: 'Hey, join me on MyFlix!' }

        expect(Invitation.count).to eq(1)
      end

      it 'sends an email to the recipient' do
        set_current_user

        post :create, invitation: { recipient_name: 'Coco', recipient_email: 'coco@example.com', message: 'Hey, join me on MyFlix!' }

        expect(ActionMailer::Base.deliveries.last.to).to eq(['coco@example.com'])
      end

      it 'sets the flash success message' do
        set_current_user

        post :create, invitation: { recipient_name: 'Coco', recipient_email: 'coco@example.com', message: 'Hey, join me on MyFlix!' }

        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      it 'renders the :new template' do
        set_current_user

        post :create, invitation: { recipient_email: 'coco@example.com', message: 'Hey, join me on MyFlix!' }

        expect(response).to render_template :new
      end

      it 'does not create an invitation' do
        set_current_user

        post :create, invitation: { recipient_email: 'coco@example.com', message: 'Hey, join me on MyFlix!' }

        expect(Invitation.count).to eq(0)
      end

      it 'does not send out an email' do
        set_current_user

        post :create, invitation: { recipient_email: 'coco@example.com', message: 'Hey, join me on MyFlix!' }

        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'sets the danger message' do
        set_current_user

        post :create, invitation: { recipient_email: 'coco@example.com', message: 'Hey, join me on MyFlix!' }

        expect(flash.now[:danger]).to be_present
      end

      it 'sets @invitation' do
        set_current_user

        post :create, invitation: { recipient_email: 'coco@example.com', message: 'Hey, join me on MyFlix!' }

        expect(assigns(:invitation)).to be_new_record
      end
    end
  end
end
