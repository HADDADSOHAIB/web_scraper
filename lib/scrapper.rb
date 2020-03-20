require 'httparty'
require 'nokogiri'

class Scrapper
  attr_reader :listings
  attr_accessor :category_number

  URL = 'https://www.avito.ma/fr/maroc/'
  CATEGORIES = %w[
    t%C3%A9l%C3%A9phones-%C3%A0_vendre
    tablettes-%C3%A0_vendre
    ordinateurs_portables-%C3%A0_vendre
  ]

  def initialize
    @listings = []
    @category_number = 0
  end

  def fetch_pages(number_pages)
    return if number_pages <= 0

    all_pages = fetch_number_of_all_pages
    range = (number_pages <= all_pages ? 1..number_pages : 1..number_pages)
    range.each do |page|
      fetch_page(page)
    end
  end

  def order_by(option)
    case option
    when 1
      @listings = @listings.sort_by { |item| item[:city] }
    when 2
      @listings = @listings.sort_by { |item| item[:price].gsub(' ','').to_i }
    else
      @listings
    end
  end

  def write
    file=File.new("data/file-#{Time.now}",'w')

    @listings.each do |item|
      file.write item[:date] + ","
      file.write item[:title] + ","
      file.write item[:city] + ","
      file.write item[:price] + ","
      file.puts
    end
  end

  private

  def process_item(item)
    date = item.css('div.item-age').text.strip
    date = format_date(date)
    title = item.css('div.item-info h2').text.strip
    city = item.css('span.item-info-extra small a').text.strip
    price = item.css('.price_value').text.strip

    { :date => date, :title => title, :city => city, :price => price }
  end

  def format_date(date)
    date = "#{date[0..-6]} #{date[-5...date.length]}"
  end

  def fetch_page(page)
    response = HTTParty.get(URL + CATEGORIES[category_number - 1] + "?o=#{page}")
    raise 'Error' if response.body.nil? || response.body.empty?

    page = Nokogiri::HTML(response.body)
    page.css(".item").each { |item| @listings << process_item(item) }
  end

  def fetch_number_of_all_pages
    response = HTTParty.get(URL + CATEGORIES[category_number - 1])
    raise 'Error' if response.body.nil? || response.body.empty?

    page = Nokogiri::HTML(response.body)
    item_per_page = page.css(".item").count
    number_listings = page.css("a#listing_tabs_all small").text.to_i
    number_listings / item_per_page + 1
  end
end