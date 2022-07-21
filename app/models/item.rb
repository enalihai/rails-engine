class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id

  def self.find_item(params)
    # binding.pry
    where("name ILIKE ?", "%#{params[:name]}%").order(:name).first
  end

  def self.find_all_items(params)
    # binding.pry
    where("name ILIKE ?", "%#{params[:name]}%").order(:name).all
  end

  def self.items_within(params)
    binding.pry
    min = params[:min_price].to_f ||= 0
    max = params[:max_price].to_f ||= Float::INFINITY
    where("unit_price >= ? AND unit_price =< ?", min, max).order(:unit_price)
  end

  def self.find_query(params)
    if ![:name].blank?
      find_item(params)
    elsif ![:min_price].blank? && [:min_price].to_f >= 0
      items_within(params).first
    elsif ![:max_price].blank? && [:min_price].to_f > 0
      items_within(params).last
    else
      binding.pry
      params.errors.full_messages
    end
  end
  
  def self.find_all_query(params)
    if ![:name].blank?
      find_all_items(params)
    elsif ![:min_price].blank? && ![:min_price].blank?
      items_within(params)
    else
      binding.pry
      params.errors.full_messages
    end
  end
end


  # def self.use_range
  #   min = params[:min_price].to_f ||= 0
  #   max = params[:max_price].to_f ||=Float::INFINITY
  #   (min, max)
  #  use a 0 / 1 flipper to say if it is valid
  # end