class Api::V1::Merchants::FindController < ApplicationController
  def index
    merchant_array = Merchant.find_all_merchants(params)
  
    render json: MerchantSerializer.new(merchant_array)
  end

  def show
    merchant = Merchant.find_merchant(params[:name])
  
    render json: MerchantSerializer.new(merchant)
  end
end

#make a handle errors method based on what number it is set to you display it
