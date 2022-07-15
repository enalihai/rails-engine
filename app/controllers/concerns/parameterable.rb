module Parameterable
  def valid_query?(params)
    if params[:name] == nil && params[:min_price] == nil && params[:max_price] == nil
      return false
    elsif params[:name] == ("") && params[:min_price] == ("") && params[:max_price] == ("")
      return false
    elsif params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      return false
    # elsif params[:name].present? && params[:min_price].present?
    #   return false
    binding.pry
    elsif !params[:name].present? && (params[:min_price].present? && params[:max_price].present?) && params[:min_price].to_f > params[:max_price].to_f
      return false
    elsif !params[:name].present? && params[:min_price].present? && params[:min_price].to_f < 0
      return false
    elsif !params[:name].present? && params[:max_price].present? && params[:max_price].to_f < 0
      return false
    else
      return true
    end
  end
end
