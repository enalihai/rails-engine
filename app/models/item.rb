class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price

  def self.find_item(name_query)
    where('name ILIKE ?', "%#{name_query}").order(:name).first
  end

  def self.find_all_items(name_query)
    where('name ILIKE ?', "%#{name_query}").order(:name)
  end

  def self.find_by_min(min_price)
    binding.pry
    where("unit_price >= ?", min_price).sort_by(:name).first
  end

  def self.find_max_item(max_price)
    where("unit_price < ?", max_price).sort_by(:unit_price).first
  end

  def self.find_min_max_item(min_price, max_price)
    where('unit_price > ? AND unit_price < ?', min_price, max_price).order(:unit_price)
  end
end
