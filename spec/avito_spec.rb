require_relative '../lib/avito.rb'

RSpec.describe Avito do
  let(:avito) do
    subject = Avito.new
    subject.category_number = 1
    subject
  end

  describe '#initialize' do
    it 'initialize all variable instance' do
      expect(avito.listings).to eql([])
      expect(avito.category_number).to eql(1)
    end
  end

  describe '#categry_number' do
    it 'Set the category number to zero if the value is less then 0' do
      avito.category_number = -1
      expect(avito.category_number).to eql(0)
    end

    it 'Set the category number to zero if the value is more then CATEGORIES size' do
      avito.category_number = Avito::CATEGORIES.size + 1
      expect(avito.category_number).to eql(0)
    end

    it 'Set the category number to the correct value' do
      avito.category_number = Avito::CATEGORIES.size - 1
      expect(avito.category_number).to eql(Avito::CATEGORIES.size - 1)
    end
  end

  describe '#fetch_pages' do
    it 'return nil if number of pages <= 0' do
      avito.category_number = 1
      expect(avito.fetch_pages(-2)).to be_nil
    end

    it 'fetch data and put it inside listings if number of pages > 0' do
      avito.category_number = 1
      avito.fetch_pages(1)
      expect(avito.listings.size).to be >= 1
    end
  end

  describe '#order_by' do
    it 'order the result by city when option 1' do
      avito.category_number = 1
      avito.fetch_pages(1)
      list_before = avito.listings.dup
      avito.order_by(1)

      expect(avito.listings).to eql(list_before.sort_by { |item| item[:city] })
    end

    it 'order the result by price when option 2' do
      avito.category_number = 1
      avito.fetch_pages(1)
      list_before = avito.listings.dup
      avito.order_by(2)

      expect(avito.listings).to eql(list_before.sort_by { |item| item[:price].gsub(' ', '').to_i })
    end

    it 'does not change the order when option 3' do
      avito.category_number = 1
      avito.fetch_pages(1)
      list_before = avito.listings.dup
      avito.order_by(3)

      expect(avito.listings).to eql(list_before)
    end
  end

  describe '#write' do
    it 'write a new file when called' do
      File.stub(:new)
      expect(File).to receive(:new)
      avito.write
    end

    it 'write a new file when called' do
      File.stub(:write)
      expect(File).to receive(:write).exactly(avito.listings.size).times
      avito.category_number = 1
      avito.fetch_pages(1)
      avito.write
    end
  end
end
