class Api::V1::Items::FindController < ApplicationController
  include Paramaterizer

  def index
    validate_query
      items = Item.find_all_items(params[:name])
      if items == nil
        render json: ErrorSerializer.no_results_found
      else
        render json: ItemSerializer.new(items)
      end
  end

  def show
    item = Item.find_item(params[:name])
    if item == nil
      render json: ErrorSerializer.no_results_found
    else
      render json: ItemSerializer.new(item)
    end
  end
end
