class Api::V1::Items::FindController < ApplicationController
  include Parameterable
  before_action :set_query_params, only: [:show, :index]
  before_action :validate_params, only: [:show, :index]

  def index
    result = ItemFacade.search(@query)

    render json: ItemSerializer.new(result)
  end

  def show
    result = ItemFacade.search(@query)

    render json: ItemSerializer.new(result)
  end

private
    def set_query_params
      @query = {name: params[:name], min_price: params[:min_price], max_price: params[:max_price]}
    end

    def validate_params
      if valid_query?(@query) == false
        render json: ErrorSerializer.invalid_parameters#{ error: 'Invalid Parameters: cant be nil'}, status: 400
      end
    end
end
