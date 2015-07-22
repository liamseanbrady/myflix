require 'spec_helper'

feature 'User following' do
  scenario 'user follows and unfollows someone' do
    alice = Fabricate(:user)
    sci_fi = Fabricate(:category)
    fringe = Fabricate(:video, title: 'Fringe', description: 'A good show', category: sci_fi)
    Fabricate(:review, author: alice, video: fringe)

    sign_in

    click_on_video_on_home_page(fringe)
    click_link alice.full_name
    click_link 'Follow'

    expect(page).to have_content(alice.full_name)

    unfollow(alice)

    expect(page).not_to have_content(alice.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end
