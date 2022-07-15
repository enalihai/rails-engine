class Api::V1::Merchants::FindController < ApplicationController
  # include Parameterizer

  def index
    # if valid_query?(params[:name])
      merchants = Merchant.find_all_merchants(params[:name])
      if merchants == nil
        render json: ErrorSerializer.no_results_found
      else
        render json: MerchantSerializer.new(merchants)
      end
    # else
    #   render json: ErrorSerializer.invalid_parameters
    # end
  end

  def show
    # if valid_query?(params[:name])
      merchant = Merchant.find_merchant(params[:name])
      if merchant == nil
        render json: ErrorSerializer.no_results_found
      else
        render json: MerchantSerializer.new(merchant)
      end
    # else
    #   render json: ErrorSerializer.invalid_parameters
    # end
  end

  # private
  #   def validate_merchant
  #     merchant = Merchant.find_merchant(params[:name])
  #   end

end
