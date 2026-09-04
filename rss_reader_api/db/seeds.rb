# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#   
feeds = [
  {
    title: "BBC News",
    url: "https://feeds.bbci.co.uk/news/rss.xml"
  },
  {
    title: "NASA",
    url: "https://www.nasa.gov/feed/"
  }
]

feeds.each do |feed_data|
  feed = Feed.find_or_create_by!(url: feed_data[:url]) do |f|
    f.title = feed_data[:title]
  end

  Feeds::FetchService.call(feed)
end

puts "Default RSS feeds created and fetched."