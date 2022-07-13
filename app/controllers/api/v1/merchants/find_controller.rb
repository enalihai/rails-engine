class Api::V1::Merchants::FindController < ApplicationController
  def index
    #active record method call here
    merchant = Merchant.where('name ILIKE ?', "%#{params[:name]}%").first
    if merchant == nil
      render json: ErrorSerializer.errors
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
