class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  def self.find_merchant(query)
    Merchant.where("name ILIKE ?", "%#{query}%").order(:name).first
  end

  def self.find_all_merchants(query)
    Merchant.where("name ILIKE ?", "%#{query}%").order(:name)
  end
end
