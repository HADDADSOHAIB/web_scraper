require_relative '../lib/avito.rb'
require_relative '../lib/marocannonce.rb'

begin
  avito = Avito.new
  marocannonce = Marocannonce.new

  puts ''
  puts 'Hello, welcome to the Scrapper.'
  puts '-------------------------------'
  puts ''
  puts ''
  category_number = 0
  while category_number == 0
    puts 'Select a Category:'
    puts '1. telephones for sale'
    puts '2. tablettes for sale'
    puts '3. Laptop for sale'
    puts '4. Playstation and Xbox'
    puts '5. Camera for sale'
    puts 'Select a category:(1, 2, 3, 4 or 5)'
    category_number = gets.chomp.to_i
  end
  marocannonce.category_number = category_number
  avito.category_number = category_number

  number_of_pages = 0
  while number_of_pages == 0
    puts 'How many pages do you want to srap:'
    number_of_pages = gets.chomp.to_i
  end

  puts 'Scrapping start ...'
  marocannonce.fetch_pages(number_of_pages)
  avito.fetch_pages(number_of_pages)
  puts 'Scrapping finished'
  puts "#{marocannonce.listings.count} entries scrapped in Maroc annonces"
  puts "#{avito.listings.count} entries scrapped in Avito"
  option = 0
  while option != 1 && option !=2 && option !=3
    puts "Order the result by: (order by date is the default)"
    puts "1. By city."
    puts "2. By Price."
    puts "3. default, by date"
    option = gets.chomp.to_i
  end

  marocannonce.order_by(option)
  avito.order_by(option)

  puts 'Do you want to save the file: (y/n)'
  option = gets.chomp
  if option == 'y' || option == 'Y'
    marocannonce.write
    avito.write
  end


rescue StandardError => e
  puts "Rescued: #{e.inspect}"
end