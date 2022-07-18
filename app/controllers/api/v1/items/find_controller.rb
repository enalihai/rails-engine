class Api::V1::Items::FindController < ApplicationController
  include Parameterable

  def index
    if valid_query?(params)
      render json: Item.find_item(params)
    else
      render json: ErrorSerializer.invalid_parameters, status: 400
    end
  end

  def show
    if valid_query?(params)
      render json: ItemFacade.search(params)
    else
      render json: ErrorSerializer.invalid_parameters, status: 400
    end
  end
end