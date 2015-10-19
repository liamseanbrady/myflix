require 'spec_helper'

feature 'Admin adds new video' do
  scenario 'successfully' do
    category = Fabricate(:category, name: 'Sci-fi')
    sign_in_as_admin

    visit new_admin_video_path

    fill_in 'Title', with: 'Fringe'
    select 'Sci-fi', from: 'Category'
    fill_in 'Description', with: 'An awesome video'
    attach_file 'Large Cover', 'spec/features/uploads/monk_large.jpg'
    attach_file 'Small Cover', 'spec/features/uploads/monk.jpg'
    fill_in 'Video URL', with: 'https://www.youtube.com/watch?v=o0gGz3IDUfw'
    click_on 'Add Video'

    expect(page).to have_content('Fringe')
    
    sign_out
    sign_in
    
    visit video_path(Video.first)

    expect(page).to have_css("img[src*='monk_large.jpg']")
    expect(page).to have_css("a[href='https://www.youtube.com/watch?v=o0gGz3IDUfw']")
  end
end
