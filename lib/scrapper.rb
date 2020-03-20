require 'httparty'
require 'nokogiri'

class Scrapper
  attr_reader :listings
  attr_accessor :category_number

  URL = 'https://www.avito.ma/fr/maroc/Z/'
  CATEGORIES = %w[
    t%C3%A9l%C3%A9phones-%C3%A0_vendre
    tablettes-%C3%A0_vendre
    ordinateurs_portables-%C3%A0_vendre
  ]

  def initialize
    @listings = []
    @category_number = 0
  end

  def fetch_page(page)
    page = Nokogiri::HTML(HTTParty.get(URL + CATEGORIES[category_number - 1] + "?o=#{page}"))
    raise 'The link is not working properly, check if the link did not change in the orginal website!' if page.nil? || page.empty?

    page.css(".item").each { |item| @listings << process_item(item) }
  end

  def fetch_pages(number_pages)
    return if number_pages <= 0

    page = Nokogiri::HTML(HTTParty.get(URL + CATEGORIES[category_number - 1]))
    raise 'The link is not working properly, check if the link did not change in the orginal website!' if page.nil? || page.empty?

    item_per_page = page.css(".item").count
    number_listings = page.css("a#listing_tabs_all small").text.to_i
    all_pages = number_listings / item_per_page + 1

    if number_pages <= all_pages
      range = 1..number_pages
    else number_pages > all_pages
      range = 1..number_pages
    end

    range.each do |page|
      fetch_page(page)
    end
  end

  def process_item(item)
    date = item.css('div.item-age').text.strip
    title = item.css('div.item-info h2').text.strip
    city = item.css('span.item-info-extra small a').text.strip
    price = item.css('.price_value').text.strip

    { :date => date, :title => title, :city => city, :price => price }
  end

  def write
    file=File.new('file.csv','w')

    @listings.each do |item|
      file.write item[:date] + ","
      file.write item[:title] + ","
      file.write item[:city] + ","
      file.write item[:price] + ","
      file.puts
    end
  end
end