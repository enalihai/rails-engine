require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer)}
    it { should belong_to(:merchant)}
    it { should have_many(:invoice_items)}
    it { should have_many(:items).through(:invoice_items)}
    it { should have_many(:transactions)}
  end

  describe 'validations' do
    it { should validate_presence_of(:status)}
  end

  describe '.self#item_required_array(item.id)' do
    it 'returns array of invoices containing ONLY query'
  end

  describe '.self#item_required_boolean(item.id)' do
    it 'returns true when invoice contains ONLY the query item'

    it 'returns false when invoice doesnt contain ONLY the query item'
  end
end
