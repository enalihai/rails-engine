class Api::V1::Items::FindController < ApplicationController
  include Parameterable

  def index
    items = Item.find_all_items(params[:name])
    if items == nil
      render json: ErrorSerializer.no_results_found, status: 400
    else
      render json: ItemSerializer.new(items)
    end
  end

  def show
    if valid_query?(params)
      render json: ItemFacade.search(params)
    else
      render json: ErrorSerializer.invalid_parameters, status: 400
    end
  end
    # if valid_query?(params)
      # item = Item.find_item(params[:name])
      # if !item == nil
      #   render json: ErrorSerializer.no_results_found
      # else
      #   render json: ItemSerializer.new(item)
      # end
    # else
    #   render json: ErrorSerializer.invalid_parameters
    # end

  # private
  #   def query_check
  #     if valid_query?(params) != true
  #       render json: ErrorSerializer.invalid_parameters, status: 404
  #     end
  #   end


end
