require_relative '../lib/marocannonce.rb'

RSpec.describe Marocannonce do
  let(:marocannonce) do
    subject = Marocannonce.new
    subject.category_number
    subject
  end

  describe '#initialize' do
    it 'initialize all variable instance' do
      expect(marocannonce.listings).to eql([])
      expect(marocannonce.category_number).to eql(0)
    end
  end

  describe '#categry_number' do
    it 'Set the category number to zero if the value is less then 0' do
      marocannonce.category_number = -1
      expect(marocannonce.category_number).to eql(0)
    end

    it 'Set the category number to zero if the value is more then CATEGORIES size' do
      marocannonce.category_number = Marocannonce::CATEGORIES.size + 1
      expect(marocannonce.category_number).to eql(0)
    end

    it 'Set the category number to the correct value' do
      marocannonce.category_number = Marocannonce::CATEGORIES.size - 1
      expect(marocannonce.category_number).to eql(Marocannonce::CATEGORIES.size - 1)
    end
  end

  describe '#fetch_pages' do
    it 'return nil if number of pages <= 0' do
      expect(marocannonce.fetch_pages(-2)).to be_nil
    end

    it 'fetch data and put it inside listings if number of pages > 0' do
      marocannonce.fetch_pages(1)
      expect(marocannonce.listings.size).to be >= 1
    end
  end

  describe '#order_by' do
    it 'order the result by city when option 1' do
      marocannonce.fetch_pages(1)
      list_before = marocannonce.listings.dup
      marocannonce.order_by(1)
      expect(marocannonce.listings).to eql(list_before.sort_by { |item| item[:city] })
    end

    it 'order the result by price when option 2' do
      marocannonce.fetch_pages(1)
      list_before = marocannonce.listings.dup
      marocannonce.order_by(2)
      expect(marocannonce.listings).to eql(list_before.sort_by { |item| item[:price].gsub(' ', '').to_i })
    end

    it 'does not change the order when option 3' do
      marocannonce.fetch_pages(1)
      list_before = marocannonce.listings.dup
      marocannonce.order_by(3)

      expect(marocannonce.listings).to eql(list_before)
    end
  end

  describe '#write' do
    it 'write a new file when called' do
      File.stub(:new)
      expect(File).to receive(:new)
      marocannonce.write
    end

    it 'write a new file when called' do
      File.stub(:write)
      expect(File).to receive(:write).exactly(marocannonce.listings.size).times
      marocannonce.fetch_pages(1)
      marocannonce.write
    end
  end
end
