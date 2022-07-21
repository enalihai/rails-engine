class Api::V1::Items::FindController < ApplicationController
  def index
    items_array = Item.find_by(params)
    
    if items_array
      render json: ItemSerializer.new(items_array)
    else
      render json: ItemSerializer.new(items_array)
    end
  end

  def show
    item = Item.find_by(params)

    if item.save
      render json: ItemSerializer.new(item)
    else
      render json: ItemSerializer.new(item)
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end