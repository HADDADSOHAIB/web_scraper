require 'httparty'
require 'nokogiri'
require_relative 'scrapper.rb'

class Avito < Scrapper
  URL = 'https://www.avito.ma/fr/maroc/'.freeze
  CATEGORIES = %w[
    t%C3%A9l%C3%A9phones-%C3%A0_vendre
    tablettes-%C3%A0_vendre
    ordinateurs_portables-%C3%A0_vendre
    jeux_vid%C3%A9o_et_consoles-%C3%A0_vendre
    appareils_photo_cameras-%C3%A0_vendre
  ].freeze

  private

  def process_item(item)
    date = item.css('div.item-age').text.strip
    date = format_date(date)
    title = item.css('div.item-info h2').text.strip
    city = item.css('span.item-info-extra small a').text.strip
    price = item.css('.price_value').text.strip
    link = item.css('h2.fs14 a')[0]['href'].strip

    { date: date, title: title, city: city, price: price, link: link }
  end

  def format_date(date)
    "#{date[0..-6]} #{date[-5...date.length]}"
  end

  def fetch_page(page)
    response = HTTParty.get(URL + CATEGORIES[category_number - 1] + "?o=#{page}")
    raise 'Error' if response.body.nil? || response.body.empty?

    page = Nokogiri::HTML(response.body)
    page.css('.item').each { |item| @listings << process_item(item) }
  end

  def fetch_number_of_all_pages
    response = HTTParty.get(URL + CATEGORIES[category_number - 1])
    raise 'Error' if response.body.nil? || response.body.empty?

    page = Nokogiri::HTML(response.body)
    item_per_page = page.css('.item').count
    number_listings = page.css('a#listing_tabs_all small').text.to_i
    number_listings / item_per_page + 1
  end
end
