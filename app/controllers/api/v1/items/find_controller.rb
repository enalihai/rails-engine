class Api::V1::Items::FindController < ApplicationController
  def index
    item = Item.where('name ILIKE ?', "%#{params[:name]}%").first
    if item == {:data=>nil}
      render json: { errors: "Not Found" }, status: 404
    else
      render json: ItemSerializer.new(item)
    end
  end
end
