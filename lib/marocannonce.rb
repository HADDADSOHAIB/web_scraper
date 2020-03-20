require 'httparty'
require 'nokogiri'
require_relative 'scrapper.rb'


class Marocannonce < Scrapper
  URL = 'https://www.marocannonces.com/maroc/'
  CATEGORIES = %w[
    telephones-portables--b359.html
    pc-bureaux-pc-portables-tablettes-b348.html
    pc-bureaux-pc-portables-tablettes-b348.html
  ]

  private

  def process_item(item)
    date = item.css('div.time').text.strip
    date = format_date(date)
    title = item.css('div.holder h3').text.strip
    city = item.css('span.location').text.strip
    price = item.css('strong.price').text.strip.gsub('DH','').strip
    link_node = item.css('div.holder a')
    link = (link_node.empty? ? " " : link_node[0]['href'])
    { :date => date, :title => title, :city => city, :price => price, :link => link }
  end

  def format_date(date)
    date = "#{date[0..-6].strip} #{date[-5...date.length]}"
  end

  def fetch_page(page)
    response = HTTParty.get(URL + CATEGORIES[category_number - 1] + "?pge=#{page}")
    raise 'Error' if response.body.nil? || response.body.empty?

    page = Nokogiri::HTML(response.body)
    page.css("ul.cars-list li").each { |item| @listings << process_item(item) }
  end

  def fetch_number_of_all_pages
    response = HTTParty.get(URL + CATEGORIES[category_number - 1] + "?pge=#{10000000}")
    raise 'Error' if response.body.nil? || response.body.empty?

    page = Nokogiri::HTML(response.body)
    number_listings = page.css(".current_li").text.to_i
  end
end