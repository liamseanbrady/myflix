# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([{ name: 'TV Comedies' }, { name: 'TV Dramas' }])

videos = {
  'Futurama' => <<-HERE_DOC,
    Phillip Fry is a 25-year-old pizza delivery boy whose life is
    going nowhere. When he accidentally freezes himself on December 31, 1999,
    he wakes up 1,000 years in the future and has a chance to make a fresh
    start. He goes to work for the Planet Express Corporation, a futuristic
    delivery service that transports packages to all five quadrants of the
    universe. His companions include the delivery ship's captain, Leela,
    a beautiful one-eyed female alien who kicks some serious butt, 
    and Bender, a robot with very human flaws.
    HERE_DOC
  'South Park' => <<-HERE_DOC,
    The curious, adventure-seeking, fourth grade group of boys, Stan, 
    Kyle, Cartman, and Kenny, all join in in buffoonish adventures
    that sometimes evolve nothing. Sometimes something that was simple
    at the start, turns out to get out of control. Everything is odd in
    the small mountain town, South Park, and the boys always find something
    to do with it.
    HERE_DOC
  'Family Guy' => <<-HERE_DOC,
    The Griffin household includes two teenagers, a cynical dog who is
    smarter than everyone else, and an evil baby who makes numerous
    attempts to eradicate his mother. Heading up this eclectic household
    is Peter Griffin. Peter does his best to do what's right for the family,
    but along the way, he makes mistakes that are the stuff of legends.
    HERE_DOC
  'Monk' => <<-HERE_DOC
    Adrian Monk is a brilliant San Francisco detective, whose obsessive
    compulsive disorder just happens to get in the way.
    HERE_DOC
  }

videos.each do |title, description|
  large_cover = (title == 'Monk' ? 'large_' : '')
  Video.create(title: title, description: description, small_cover_url: "/tmp/#{title.parameterize.underscore}.jpg", large_cover_url: "/tmp/#{large_cover}#{title.parameterize.underscore}.jpg", category: categories.sample)
end

