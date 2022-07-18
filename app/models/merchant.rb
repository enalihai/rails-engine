class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  validates :attributes, :name
  
  def self.find_merchant(query)
    where("name ILIKE ?", "%#{query}%").order(:name).first
  end

  def self.find_all_merchants(query)
    where("name ILIKE ?", "%#{query}%").order(:name)
  end
end
