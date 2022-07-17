module Parameterable
  def valid_query?
    valid = 1
    # return false if params.values_at(:name, :min_price, :max_price).all?(&:present?)
    # return false if params.values_at(:name, :min_price).all?(&:present?)
    # return false if params.values_at(:name, :max_price).all?(&:present?)
    # return false if params.values_at(:min_price, :max_price).any? {|q| q.to_f < 0 }
    # return false if params.values_at(:name, :min_price).all?(&:present?)
    # search that they are not all empty, but doesnt ruin merchant
    # return false if params.values_at(:name, :max_price).all?(&:present?)
    # return false if params.values_at(:min_price, :max_price).any? {|q| q.to_f < 0 }
  end
end
# [:name, :min_price, :max_price].any? { |key| self.key?(key) }
# possible easier way
# def self.validate_name_query, end
#
# def self.validate_price_query, end
# def
# elsif [:min_price, :max_price].all? && params[:min_price].to_f > params[:max_price].to_f
#   false
# elsif !params[:name].present? && params[:min_price].present? && params[:min_price].to_f < 0
#   false
# elsif !params[:name].present? && params[:max_price].present? && params[:max_price].to_f < 0
#   false
# else
#   true
# end
# if params[:name] == nil && params[:min_price] == nil && params[:max_price] == nil
#   false
