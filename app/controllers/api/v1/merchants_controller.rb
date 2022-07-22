class Api::V1::MerchantsController < ApplicationController
  def index
    render json: ErrorSerializer.null_result if Merchant.all == []
    render json: MerchantSerializer.new(Merchant.all), status: 200
  end

  def show
    merchant = Merchant.find(params[:id])

    render json: ErrorSerializer.null_result if merchant == nil
    render json: MerchantSerializer.new(merchant), status: 200
  end
end
