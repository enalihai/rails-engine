module Paramaterizer
  def validate_query
    if params[:name] == ''
      render json: ErrorSerializer.cant_be_blank
    elsif params[:name] == nil
      render json: ErrorSerializer.nil_query
    elsif !params.has_key?(:name)
      render json: ErrorSerializer.invalid_parameters
    end
  end
end
