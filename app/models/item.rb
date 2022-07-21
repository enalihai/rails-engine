class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id
  
  def self.find_item(params)
    where("name ILIKE ?", "%#{params}%").order(:name).first
  end

  def self.find_all_items(params)
    where("name ILIKE ?", "%#{params}%").order(:name).all
  end

  def self.items_within(min, max)
    min ||= 0
    max ||= Float::INFINITY
    where("unit_price >= ? AND unit_price <= ?", "#{min}", "#{max}").order(:unit_price).all
  end

  def self.find_by(params)
    if params[:action] == "show"
      find_query(params)
    else
      find_all_query(params)
    end
  end
  
  def self.find_query(params)
    if !params[:name].blank?
      find_item(params[:name])
    elsif ![:min_price].blank? && params[:min_price].to_f >= 0
      items_within(params[:min_price].to_f, params[:max_price]).first
    elsif ![:max_price].blank? && params[:max_price].to_f > 0
      items_within(0, params[:max_price].to_f).last
    else
      params.errors.full_messages
    end
  end
  
  def self.find_all_query(params)
    if ![:name].blank?
      find_all_items(params)
    elsif ![:min_price].blank? && ![:max_price].blank?
      items_within(min, max).all
    else
      params.errors.full_messages
    end
  end
end

  #### PRIVATE --- would allow you to have no class methods
