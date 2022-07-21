class Api::V1::Items::FindController < ApplicationController
  def index
    items_array = Item.find_all_query(params)
    
    if items_array
      render json: ItemSerializer.new(items_array)
    else
      render json: ItemSerializer.new(items_array)
    end
  end

  def show
    item = Item.find_query(params)

    if item.save
      render json: ItemSerializer.new(item)
    else
      render json: ItemSerializer.new(item)
    end
  end

  private

  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id)
  end
end