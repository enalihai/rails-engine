module Parameterizer
  def valid_query?(params)
    if params[:name] == nil && params[:min_price] == nil && params[:max_price] == nil
      return false
    elsif params[:name] == ('') || params[:min_price] == ('') || params[:max_price] == ('')
      return false
    elsif params.has_key?(:name) && params.has_key?(:min_price)
      return false
    elsif params.has_key?(:name) && params.has_key?(:max_price)
      return false
    elsif params.has_key?(:name) && params.has_key?(:max_price) && params[:min_price].to_f > params[:max_price].to_f
      return false
    else
      return true
    end
  end
end