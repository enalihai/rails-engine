class Api::V1::Items::FindController < ApplicationController
  include Parameterable

  def index
    # if !valid_query?(params)
    #   render json: ErrorSerializer.invalid_query, status: 400
    # else
      item_array = Item.search(params)
      render json: ItemSerializer.new(item_array)
    # end
  end

  def show
    # if !valid_query?(params)
    #   render json: ErrorSerializer.invalid_query, status: 400
    # else
      item = Item.search(params)
      render json: ItemSerializer.new(item)
    # end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :range, , )
  end
end
#allow strong params here
