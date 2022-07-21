# class FilterQueriesValidator < ActiveModel::EachValidator
#   def validate_each(record, attribute, value)
#     return unless record.include?(options[:in].first)
#   end
  # def validate(params)
  #   if params.values_at(:min_price, :max_price).any? {|q| q.to_f < 0 }
  #     params.errors.add :base, :invalid, message: 'INVALID :: Query uses invalid format'
  #   elsif params.values_at(:name, :min_price, :max_price).all? {|q| q.blank? }
  #     params.errors.add :base, :invalid, message: 'INVALID :: Query uses invalid format'
  #   elsif params.values_at(:min_price, :max_price).present? && params[:min_price].to_f > params[:max_price].to_f
  #     params.errors.add :base, :min_max, message: 'MINMAX :: Min > Max not allowed'
  #   elsif params.values_at(:name, :min_price, :max_price).present?
  #     params.errors.add :base, :null, message: 'INVALID :: No matching query is available'
  #   else
  #     return true
  #   end
  # end
# end