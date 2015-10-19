require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted', { js: true, vcr: true } do
    alice = Fabricate(:user)
    sign_in(alice)
    
    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    friend_should_follow(alice)
    inviter_should_follow_friend(alice)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's name", with: 'Bob Doe'
    fill_in 'Email Address', with: 'bob@example.com'
    fill_in 'Invitation Message', with: 'Please join MyFlix'
    click_button 'Send Invitation'
    sign_out
  end

  def friend_accepts_invitation
    open_email('bob@example.com')
    current_email.click_link 'Accept this invitation'
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Bob Doe'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '123'
    select '12 - December', from: 'date_month'
    select '2018', from: 'date_year'
    click_button 'Register and Pay'
  end

  def friend_signs_in
    page.find('#email').set('bob@example.com')
    page.find('#password').set('password')
    click_button 'Sign in'
  end

  def friend_should_follow(user)
    click_link 'People'
    expect(page).to have_content(user.full_name)
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link 'People'
    expect(page).to have_content('Bob Doe')
  end
end
