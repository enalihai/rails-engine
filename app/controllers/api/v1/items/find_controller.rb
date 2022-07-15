class Api::V1::Items::FindController < ApplicationController
  include Parameterable
  before_action :set_query_params, only: [:index, :show]

  def index
    binding.pry
    if valid_query?(@query)
      result = ItemFacade.search(@query)

      render json: ItemSerializer.new(result), status: 200
    else
      render json: ErrorSerializer.invalid_parameters, status: 400
    end
  end

  def show
    binding.pry
    if valid_query?(@query)
      result = ItemFacade.search(@query)

      render json: ItemSerializer.new(result), status: 200
    else
      render json: ErrorSerializer.invalid_parameters, status: 400
    end
  end

  private

    def set_query_params
      @query = {name: params[:name], min_price: params[:min_price], max_price: params[:max_price]}
    end
end
