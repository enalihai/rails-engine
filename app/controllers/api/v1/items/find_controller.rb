class Api::V1::Items::FindController < ApplicationController
  def index
    items_array = Item.find_all_items(params)
    if items_array == nil
      render json: ErrorSerializer.null_result, code: 400
    else
      render json: ItemSerializer.new(items_array), status: 200
    end
  end

  def show
    item = Item.find_item(params)
    render json: ErrorSerializer.null_result, code: 400 if item == nil
    render json: ItemSerializer.new(item), status: 200
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end