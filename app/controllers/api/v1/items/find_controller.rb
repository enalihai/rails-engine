class Api::V1::Items::FindController < ApplicationController
  # include Parameterizer

  def index
    # if valid_query?(params)
    items = Item.find_all_items(params[:name])
    if items == nil
      render json: ErrorSerializer.no_results_found
    else
      render json: ItemSerializer.new(items)
    end
  end

  def show
    # if valid_query?(params)
      item = Item.find_item(params[:name])
      if !item == nil
        render json: ErrorSerializer.no_results_found
      else
        render json: ItemSerializer.new(item)
      end
    # else
    #   render json: ErrorSerializer.invalid_parameters
    # end
  end
end
