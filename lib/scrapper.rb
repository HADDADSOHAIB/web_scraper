require 'httparty'
require 'nokogiri'

class Scrapper
  def initialize
    @url = 'https://www.avito.ma/fr/maroc/t%C3%A9l%C3%A9phones-%C3%A0_vendre'
    @listings = []
  end

  def fetch_page(page)
    page = Nokogiri::HTML(HTTParty.get(@url + "?o=#{page}"))
    page.css(".item").each { |item| @listings << process_item(item) }
  end

  def fetch_all_pages
    page = Nokogiri::HTML(HTTParty.get(@url))
    item_per_page = page.css(".item").count
    number_listings = page.css("a#listing_tabs_all small").text.to_i
    number_pages = number_listings / item_per_page + 1
    (1..number_pages).each do |page|
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
end