class Api::V1::Items::FindController < ApplicationController
  include Parameterizer
  before_action :query_check

  def index
    items = Item.find_all_items(params[:name])
    if items == nil
      render json: ErrorSerializer.no_results_found
    else
      render json: ItemSerializer.new(items)
    end
  end

  def show
    # binding.pry
    render json: ItemFacade.search(params)
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
  end

  private
    def query_check
      render json: ErrorSerializer.invalid_parameters, status: 404 if valid_query?(params) != true
    end
end
