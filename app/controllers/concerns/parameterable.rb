module Parameterable
  def valid_query?(params)
    return false if params.values_at(:min_price, :max_price).any? {|q| q.to_f < 0 }
    return false if params[:name] == nil && params[:min_price] == nil && params[:max_price] == nil
      set_error_code == 1
    elsif [:min_price, :max_price].any? && params[:min_price].to_f > params[:max_price].to_f
      return true
    end
  end
end
