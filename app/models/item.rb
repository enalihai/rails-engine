class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price

  def self.find_item(query)
    where("name ILIKE ?", "%#{query}%").order(:name).first
  end

  def self.find_all_items(query)
    where("name ILIKE ?", "%#{query}%").order(:name)
  end

  def self.find_by_min(min_price)
    where("unit_price >= ?", min_price).order(:unit_price).first
  end

  def self.find_max_item(max_price)
    where("unit_price >= ?", max_price).order(:unit_price).last
  end

  def self.find_min_max_item(min_price, max_price)
    # where('items.unit_price >= ? AND items', max_price).order(:name).last
  end
end
