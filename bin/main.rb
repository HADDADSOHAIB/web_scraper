require_relative '../lib/scrapper.rb'

begin
  scrapper = Scrapper.new

  puts ''
  puts 'Hello, welcome to the Scrapper.'
  puts '-------------------------------'
  puts ''
  puts ''

  while scrapper.category_number == 0
    puts 'Select a Category:'
    puts '1. téléphones à vendre'
    puts '2. tablettes à vendre'
    puts '3. ordinateurs portables à vendre'
    puts 'Select a category:(1, 2 or 3)'
    scrapper.category_number = gets.chomp.to_i
  end

  number_of_pages = 0

  while number_of_pages == 0
    puts 'How many pages do you want to srap:'
    number_of_pages = gets.chomp.to_i
  end

  puts 'Scrapping start ...'
  scrapper.fetch_pages(number_of_pages)
  puts 'Scrapping finished'
  puts "#{scrapper.listings.count} entries scrapped"
  puts 'Do you want to save the file: (y/n)'
  option = gets.chomp
  if option == 'y' || option == 'Y'
    scrapper.write
  end


rescue StandardError => e
  puts "Rescued: #{e.inspect}"
end