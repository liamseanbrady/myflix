require 'spec_helper'

feature 'Visitor makes payment' do
  scenario 'with valid user info and valid card number', :vcr, :js do
    visit register_path
    
    fill_in_valid_user
    fill_in_valid_card
    click_button 'Register and Pay'

    expect(page).to have_content('Thank you for registering with MyFlix. Please sign in now')
  end

  scenario 'with valid user info and invalid card number', :vcr, :js do
    visit register_path

    fill_in_valid_user
    fill_in_invalid_card
    click_button 'Register and Pay'

    expect(page).to have_content("This card number looks invalid")
  end

  scenario 'with valid user info and declined card', :vcr, :js do
    visit register_path

    fill_in_valid_user
    fill_in_declined_card
    click_button 'Register and Pay'

    expect(page).to have_content('Your card was declined.')
  end

  scenario 'with invalid user info and valid card', :vcr, :js do
    visit register_path

    fill_in_invalid_user
    fill_in_valid_card
    click_button 'Register and Pay'

    expect(page).to have_content("Invalid user information. Please check the errors below")
  end

  scenario 'with invalid user info and invalid card', :vcr, :js do
    visit register_path

    fill_in_invalid_user
    fill_in_invalid_card
    click_button 'Register and Pay'

    expect(page).to have_content("This card number looks invalid")
  end

  scenario 'with invalid user info and declined card', :vcr, :js do
    visit register_path

    fill_in_invalid_user
    fill_in_declined_card
    click_button 'Register and Pay'

    expect(page).to have_content("Invalid user information. Please check the errors below")
  end

  def fill_in_valid_card
    fill_in 'credit-card-number', with: '4242424242424242'
    fill_in 'security-code', with: '123'
    select '3 - March', from: 'date_month'
    select '2016', from: 'date_year'
  end

  def fill_in_invalid_card
    fill_in 'credit-card-number', with: '123'
    fill_in 'security-code', with: '123'
    select '3 - March', from: 'date_month'
    select '2016', from: 'date_year'
  end

  def fill_in_declined_card
    fill_in 'credit-card-number', with: '4000000000000002'
    fill_in 'security-code', with: '123'
    select '3 - March', from: 'date_month'
    select '2016', from: 'date_year'
  end

  def fill_in_valid_user
    fill_in 'Email Address', with: 'bob@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Bob Doe'
  end

  def fill_in_invalid_user
    fill_in 'Email Address', with: 'bob@example.com'
  end
end
