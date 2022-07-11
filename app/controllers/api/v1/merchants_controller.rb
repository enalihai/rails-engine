class Api::V1::MerchantsController < ApplicationController
  # before_action :set_merchant, only: [:show, :update, :destroy]

  def index
    render json: Merchant.all
  end

  def show
    render json: Merchant.find(params[:id])
  end
  #
  # def create
  #   @api_v1_merchant = Api::V1::Merchant.new(api_v1_merchant_params)
  #
  #   if @api_v1_merchant.save
  #     render json: @api_v1_merchant, status: :created, location: @api_v1_merchant
  #   else
  #     render json: @api_v1_merchant.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # def update
  #   if @api_v1_merchant.update(api_v1_merchant_params)
  #     render json: @api_v1_merchant
  #   else
  #     render json: @api_v1_merchant.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # def destroy
  #   @api_v1_merchant.destroy
  # end
  #
  private
    # def set_merchant
    #   merchant = Merchant.find(params[:id])
    # end
  #
  #   def api_v1_merchant_params
  #     params.fetch(:api_v1_merchant, {id: params[:id], name: params[:name]})
  #   end
end
