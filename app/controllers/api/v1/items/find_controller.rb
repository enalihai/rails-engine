class Api::V1::Items::FindController < ApplicationController
  def index
    items = Item.where('name ILIKE ?', "%#{params[:name]}%")
    if item == nil
      render json: ErrorSerializer.no_results_found
    else
      render json: ItemSerializer.new(items)
    end
  end

  def show
    item = Item.where('name ILIKE ?', "%#{params[:name]}%").first
    if item == nil
      render json: ErrorSerializer.no_results_found
    else
      render json: ItemSerializer.new(item)
    end
  end
end
