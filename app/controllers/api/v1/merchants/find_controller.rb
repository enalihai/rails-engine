class Api::V1::Merchants::FindController < ApplicationController
  def index
    if !params[:name].blank?
      merchants_array = Merchant.find_all_merchants(params)
      render json: MerchantSerializer.new(merchants_array), status: 200
    else
      render json: ErrorSerializer.null_result, status: 400
    end
  end

  def show
    if !params[:name].blank?
      merchant = Merchant.find_merchant(params)
      render json: MerchantSerializer.new(merchant), status: 200
    else
      render json: ErrorSerializer.null_result, status: 400
    end
  end
end