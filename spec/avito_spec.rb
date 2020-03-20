require_relative '../lib/avito.rb'

RSpec.describe Avito do
  let(:avito){ Avito.new }
  describe '#initialize' do
    it 'initialize all variable instance' do
      expect(avito.listings).to eql([])
      expect(avito.category_number).to eql(0)
    end
  end
end