require 'spec_helper'

feature 'Admin sees payments' do
  background do
    alice = Fabricate(:user, full_name: 'Alice Adams', email: 'alice@example.com')
    Fabricate(:payment, user: alice, amount: 999)
  end

  scenario 'admin can see payments', :vcr do
    sign_in(Fabricate(:admin))

    visit admin_payments_path
    
    expect(page).to have_content('Alice Adams')
    expect(page).to have_content('alice@example.com')
    expect(page).to have_content('$9.99')
  end

  scenario 'user cannot see payments' do
    sign_in(Fabricate(:user))

    visit admin_payments_path
    
    expect(page).not_to have_content('Alice Adams')
    expect(page).not_to have_content('$9.99')
    expect(page).to have_content('You are not allowed to access this area')
  end
end
