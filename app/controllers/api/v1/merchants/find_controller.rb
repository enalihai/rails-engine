class Api::V1::Merchants::FindController < ApplicationController
  def index
    merchants = Merchant.find_all_merchants(params[:name])
    if merchants == nil
      render json: ErrorSerializer.no_results_found
    else
      render json: MerchantSerializer.new(merchants)
    end
  end

  def show
    merchant = Merchant.find_merchant(params[:name])
    if merchant == nil
      render json: ErrorSerializer.no_results_found
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  # private
  #   def validate_merchant
  #     merchant = Merchant.find_merchant(params[:name])
  #   end

end
