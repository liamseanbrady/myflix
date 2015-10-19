Fabricator(:video) do
  title { Faker::Lorem.words(4).join(' ') }
  description { Faker::Lorem.paragraph(2) }
  video_url { Faker::Internet.url }
end
