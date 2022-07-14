module Paramaterizer
  def validate_query
    if params[:name] == ''
      render json: ErrorSerializer.cant_be_blank
    end 
  end
end
