class Api::V1::Items::FindController < ApplicationController
  def index
    #active record call here
    item = Item.where('name ILIKE ?', "%#{params[:name]}%").first
    if item == nil
      render json: ErrorSerializer.errors
    else
      render json: ItemSerializer.new(item)
    end
  end
end
