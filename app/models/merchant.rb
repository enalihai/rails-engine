class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  def self.find_merchant(query)
    where("name ILIKE ?", "%#{query[:name]}%").order(:name).first
  end

  def self.find_all_merchants(query)
    where("name ILIKE ?", "%#{query[:name]}%").order(:name).all
  end
end
