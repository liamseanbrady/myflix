require 'spec_helper'

feature 'User interacts with queue' do
  scenario 'by adding and reordering videos in the queue' do
    tv = Fabricate(:category)
    fringe = Fabricate(:video, title: 'Fringe', category: tv)
    friends = Fabricate(:video, title: 'Friends', category: tv)
    breaking_bad = Fabricate(:video, title: 'Breaking Bad', category: tv)
    sign_in

    add_video_to_queue(fringe)
    expect_video_to_be_in_queue(fringe)

    visit video_path(fringe)
    expect_link_not_to_be_seen('+ My Queue')

    add_video_to_queue(friends)
    add_video_to_queue(breaking_bad)

    set_video_position(fringe, 2)
    set_video_position(friends, 3)
    set_video_position(breaking_bad, 1)

    update_queue

    expect_video_position(breaking_bad, 1)
    expect_video_position(fringe, 2)
    expect_video_position(friends, 3)
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link('+ My Queue')
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content "#{video.title}"
  end

  def expect_link_not_to_be_seen(link)
    expect(page).not_to have_content(link)
  end
  
  def update_queue
    click_button('Update Instant Queue')
  end
end
