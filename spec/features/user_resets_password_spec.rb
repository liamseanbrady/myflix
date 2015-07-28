require 'spec_helper'

feature 'User resets password' do
  scenario 'user resets password and signs in with new password' do
    visit home_path

    click_link 'Forgot password?'
  end
end
