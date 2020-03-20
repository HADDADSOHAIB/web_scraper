require_relative '../lib/avito.rb'
require_relative '../lib/marocannonce.rb'

# begin
  # scrapper = Avito.new
  marocannonce = Marocannonce.new

  puts ''
  puts 'Hello, welcome to the Scrapper.'
  puts '-------------------------------'
  puts ''
  puts ''
  category_number = 0
  while category_number == 0
    puts 'Select a Category:'
    puts '1. téléphones à vendre'
    puts '2. tablettes à vendre'
    puts '3. ordinateurs portables à vendre'
    puts 'Select a category:(1, 2 or 3)'
    category_number = gets.chomp.to_i
  end
  marocannonce.category_number = category_number

  number_of_pages = 0
  while number_of_pages == 0
    puts 'How many pages do you want to srap:'
    number_of_pages = gets.chomp.to_i
  end

  puts 'Scrapping start ...'
  marocannonce.fetch_pages(number_of_pages)
  puts 'Scrapping finished'
  puts "#{marocannonce.listings.count} entries scrapped"
  option = 0
  while option != 1 && option !=2 && option !=3
    puts "Order the result by: (order by date is the default)"
    puts "1. By city."
    puts "2. By Price."
    puts "3. default, by date"
    option = gets.chomp.to_i
  end

  marocannonce.order_by(option)

  puts 'Do you want to save the file: (y/n)'
  option = gets.chomp
  if option == 'y' || option == 'Y'
    marocannonce.write
  end


# rescue StandardError => e
#   puts "Rescued: #{e.inspect}"
# end