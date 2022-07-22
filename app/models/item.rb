class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id
  
  def self.find_item(params)
    where("name ILIKE ?", "%#{params[:name]}%").order(:name).first
  end

  def self.find_all_items(params)
    where("name ILIKE ?", "%#{params[:name]}%").order(:name).all
  end

  def self.items_within(params)
    if params[:min_price].blank? && !params[:max_price].blank? && params[:name].blank?
      min = 0
      max = params[:max_price].to_f
      where("unit_price > ? AND unit_price < ?", min, max).order(:unit_price).last
    elsif params[:max_price].blank? && !params[:min_price].blank?
      min = params[:min_price].to_f
      max = 5000000000000000
      where("unit_price > ? AND unit_price < ?", min, max).order(:unit_price).first
    elsif !params[:max_price].blank? && !params[:min_price].blank? 
      min = params[:min_price].to_f
      max = params[:max_price].to_f
      where("unit_price >= ? AND unit_price <= ?", min, max).order(:unit_price).all
    else
      ErrorSerializer.new(error: "UNKNOWN :: No valid query can be found!")
    end
  end
  
  def self.find_all_query(params)
    if params[:name].blank? && !params[:min_price].blank? && !params[:max_price].blank?
      if params[:min_price].to_f > params[:max_price].to_f
        {error: "MIN#MAX :: Min cant be greater than max!"}
      elsif params[:min_price].to_f < 0 || params[:max_price].to_f < 0
        {error: "MIN#MAX :: Queries cant be less than 0!"}
      elsif params[:name].blank? && !params[:min_price].blank? && !params[:max_price].blank? 
        items_within(params)
      else
        {error: "MIN#MAX :: NO METHODS FOUND!"}
      end
    elsif !params[:name].blank? && params[:min_price].blank? && params[:max_price].blank?
      find_all_items(params)
    else
      {error: "UNKNOWN :: No valid query can be found!"}
    end
  end    
  
  def self.find_query(params)
    if params[:name].blank? && params[:min_price].blank? && !params[:max_price].blank?
      items_within(params)
    elsif params[:name].blank? && !params[:min_price].blank? && params[:max_price].blank?
      items_within(params)
    elsif params[:name] && params[:min_price].blank? && params[:max_price].blank?
      find_item(params)
    else
      {error: 'NOQUERY :: No valid methods found!'}
    end
  end
end