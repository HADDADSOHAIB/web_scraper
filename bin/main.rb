require_relative '../lib/scrapper.rb'

scrapper = Scrapper.new

scrapper.fetch_pages(10)

p scrapper.listings.count

scrapper.write