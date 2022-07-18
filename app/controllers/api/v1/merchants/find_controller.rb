class Api::V1::Merchants::FindController < ApplicationController
  include Parameterable

  def index
    # merchants_array = Merchant.find_all_merchants(params)
    # if merchants_array == nil || merchants_array == []
    #   render json: ErrorSerializer.invalid_query
    # elsif merchants_array == []
    #   render json: ErrorSerializer.no_match
    # else
    #   render json: MerchantSerializer.new(merchants_array)
    # end
  end

  def show
    merchant = Merchant.find_merchant(params[:name])
  #   if merchant == nil
  #     render json: ErrorSerializer.invalid_query
  #   else
    render json: MerchantSerializer.new(merchant)
  #   end
  end

  private

  def validate_query
    render json: ErrorSerializer.if params.key? :name 
  end
end

#make a handle errors method based on what number it is set to you display it
