class Api::V1::Merchants::FindController < ApplicationController
  include Parameterable
  before_action :set_query_params, only: [:show, :index]
  # before_action :validate_params, only: [:show, :index]

  def index
      merchants = Merchant.find_all_merchants(@query)
      if merchants == nil
        render json: ErrorSerializer.no_results_found
      else
        render json: MerchantSerializer.new(merchants)
      end
  end

  def show
    merchant = Merchant.find_merchant(@query)
    if merchant == nil
      render json: ErrorSerializer.no_results_found
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  private
  def set_query_params
    @query = params[:name]
  end

  # def validate_params
  #   if !valid_query?(@query)
  #     render json: ErrorSerializer.invalid_parameters
  #   end
  # end
end
