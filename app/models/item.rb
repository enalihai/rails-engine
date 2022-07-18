class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description 
  validates_presence_of :unit_price 
  validates_presence_of :merchant_id
  
  def self.find_item(name)
    where("name ILIKE ?", "%#{name}%").order(:name).first
  end

  def self.find_all_items(name)
    where("name ILIKE ?", "%#{name}").order(:name)
  end

  def self.items_within(range)
    min = range[:min_price].to_f ||= 0
    max = range[:max_price].to_f ||= Float::INFINITY
    where("unit_price >= ? AND unit_price =< ?", min, max).order(:unit_price)
  end
end


  # def self.use_range
  #   min = params[:min_price].to_f ||= 0
  #   max = params[:max_price].to_f ||=Float::INFINITY
  #   (min, max)
  #  use a 0 / 1 flipper to say if it is valid
  # end