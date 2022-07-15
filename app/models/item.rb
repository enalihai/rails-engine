module Parameterizer
class Item < ApplicationRecord

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price

  def self.find_item(query)
    where('name ILIKE ?', "%#{query}%").order(:name).first
  end

  def self.find_all_items(query)
    where('name ILIKE ?', "%#{query}%").order(:name)
  end

  def self.find_by_min(min_price)
    binding.pry
    where('unit_price >= ?', min_price).sort(:unit_price).first
  end

  def self.find_max_item(max_price)

  end

  def self.find_min_max_item(min_price, max_price)
  end

  private

  def query_check
    binding.pry
    if valid_query?(params) != true
      binding.pry
      render json: ErrorSerializer.invalid_parameters, status: 404
    end
  end
end
