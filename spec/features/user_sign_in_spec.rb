require 'spec_helper'

feature 'User signs in' do
  scenario 'with valid email and password' do
    alice = Fabricate(:user)
    
    sign_in(alice)

    expect(page.has_content?("#{alice.full_name}")).to be true
  end
end
