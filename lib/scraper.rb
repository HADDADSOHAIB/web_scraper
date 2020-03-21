class Scraper
  attr_reader :listings, :category_number

  def initialize
    @listings = []
    @category_number = 0
  end

  def category_number=(value)
    @category_number = (value.positive? && value <= self.class::CATEGORIES.size ? value : 0)
  end

  def fetch_pages(number_pages)
    return nil if number_pages <= 0

    all_pages = fetch_number_of_all_pages
    range = (number_pages <= all_pages ? 1..number_pages : 1..all_pages)
    range.each do |page|
      fetch_page(page)
    end
  end

  def order_by(option)
    case option
    when 1
      @listings = @listings.sort_by { |item| item[:city] }
    when 2
      @listings = @listings.sort_by { |item| item[:price].gsub(' ', '').to_i }
    else
      @listings
    end
  end

  def write
    file = File.new("data/category-#{@category_number}-#{self.class}-#{Time.now}.csv", 'w')

    @listings.each do |item|
      file.write item[:date] + ','
      file.write item[:title] + ','
      file.write item[:city] + ','
      file.write item[:price] + ','
      file.write item[:link] + ','
      file.puts
    end
  end

  private

  def process_item(item); end

  def format_date(date); end

  def fetch_page(page); end

  def fetch_number_of_all_pages; end
end
