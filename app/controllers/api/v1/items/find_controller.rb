class Api::V1::Items::FindController < ApplicationController
  def index
    item = Item.where(name: params[:name]).first
    render json: ItemSerializer.new(item)
  end
end
