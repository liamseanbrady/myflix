require 'spec_helper'

describe Admin::PaymentsController do
  describe 'GET index' do
    it 'sets @payments ivar' do
      set_current_admin
      payment = Fabricate(:payment)

      get :index
      
      expect(assigns(:payments)).to eq([payment])
    end
  end
end
