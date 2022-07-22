class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    
    render json: ItemSerializer.new(merchant.items), status: 200
  end
end
