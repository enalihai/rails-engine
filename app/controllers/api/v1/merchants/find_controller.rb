class Api::V1::Merchants::FindController < ApplicationController
  def index
    merchant_array = Merchant.find_all_merchants(merchant_params)
  
    render json: MerchantSerializer.new(merchant_array)
  end

  def show
    merchant = Merchant.find_merchant(merchant_params)
  
    render json: MerchantSerializer.new(merchant)
  end

  private

  def merchant_params
    params.permit(:name)
  end
end

#make a handle errors method based on what number it is set to you display it
