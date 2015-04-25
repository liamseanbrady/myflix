require 'spec_helper'

feature 'User interacts with queue' do
  scenario 'by adding and reordering videos in the queue' do
    tv = Fabricate(:category)
    fringe = Fabricate(:video, title: 'Fringe', category: tv)
    friends = Fabricate(:video, title: 'Friends', category: tv)
    breaking_bad = Fabricate(:video, title: 'Breaking Bad', category: tv)
    sign_in

    find("a[href='/videos/#{fringe.id}']").click
    expect(page).to have_content "#{fringe.title}"

    click_link('+ My Queue')
    expect(page).to have_content "#{fringe.title}"

    visit video_path(fringe)
    expect(page).not_to have_content '+ My Queue'

    visit home_path
    find("a[href='/videos/#{friends.id}']").click
    click_link('+ My Queue')

    visit home_path
    find("a[href='/videos/#{breaking_bad.id}']").click
    click_link('+ My Queue')

    within(:xpath, "//tr[contains(.,'#{fringe.title}')]") do
      fill_in "queue_items[][position]", with: 2
    end

    within(:xpath, "//tr[contains(.,'#{friends.title}')]") do
      fill_in "queue_items[][position]", with: 3
    end

    within(:xpath, "//tr[contains(.,'#{breaking_bad.title}')]") do
      fill_in "queue_items[][position]", with: 1
    end

    click_button('Update Instant Queue')

    expect(find(:xpath, "//tr[contains(.,'#{breaking_bad.title}')]//input[@type='text']").value).to eq('1')


    expect(find(:xpath, "//tr[contains(.,'#{fringe.title}')]//input[@type='text']").value).to eq('2')

    expect(find(:xpath, "//tr[contains(.,'#{friends.title}')]//input[@type='text']").value).to eq('3')
  end
end
