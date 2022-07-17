class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price, :merchant_id

  def self.find_item(name_query)
    where('name ILIKE ?', "%#{name_query}%").order(:name).first
  end

  def self.find_all_items(name_query)
    where('name ILIKE ?', "%#{name_query}%").order(:name)
  end

  def self.find_within_range(range)
    min = range[:min_price].to_f ||= 0
    max = range[:max_price].to_f ||= Float::INFINITY

    where('unit_price >= ? AND unit_price <= ?', min, max).order(:name)
  end

  def self.by_name?(params)
    return true if params[:name].present?
  end

  def self.by_price?(params)
    return true if params.values_at(:name, :min_price).any?(&:present?)
  end

  def self.search(query)
    binding.pry
    find_item(query[:name]) if by_name?(query)
    find_within_range(query) if by_price?(query)
    find_all_items(query)
  end
end
