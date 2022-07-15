module Parameterizer
  def valid_query?(params)
    # binding.pry
    if params[:name] == nil && (params[:min_price] == nil && params[:max_price] == nil)
      return false
    elsif params[:name] == ('') || params[:min_price] == ('') || params[:max_price] == ('')
      return false
    elsif params[:name] && (params[:min_price] != nil || params[:max_price] != nil)
      return false
    elsif params[:name] == nil && (params[:min_price] != nil && params[:max_price] != nil) && (params[:min_price].to_f > params[:max_price].to_f)
      return false
    else
      return true
    end
  end
end
