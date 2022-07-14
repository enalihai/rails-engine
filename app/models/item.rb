class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price

  def self.find_item(query)
    Item.where('name ILIKE ?', "%#{query}%").order(:name).first
  end

  def self.find_all_items(query)
    Item.where('name ILIKE ?', "%#{query}%").order(:name)
  end
end
