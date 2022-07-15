class ItemFacade
  def self.search(query_params)
    binding.pry
    if query_params[:name].present? && !query_params[:min_price].present? && !query_params[:min_price].present?
      find_item_by_name(query_params[:name])
    elsif !query_params[:name].present? && query_params[:min_price].present? && !query_params[:max_price].present?
      find_min_item(query_params[:min_price])
    elsif !query_params[:name].present && !query_params[:min_price].present? && query_params[:max_price].present?
      find_max_item(query_params[:max_price])
    elsif !query_params[:name].present? && query_params[:min_price].present? && query_params[:max_price].present?
      find_items_within_range(query_params[:min_price], query_params[:max_price])
    else
      ErrorSerializer.nil_query
    end
  end

  def self.find_item_by_name(name)
    query_item = Item.find_item(name)
    if query_item == nil
      ErrorSerializer.no_results_found
    else
      binding.pry
      ItemSerializer.new(query_item)
    end
  end

  def self.find_all_items_by_name(query_params)
    name = query_params[:name]
    query_items = Item.find_all_items(name)
    if query_items == nil
      render json: ErrorSerializer.no_results_found, status: 400
    else
      query_items
    end
  end

  def self.find_min_item(query_params)
    item = Item.find_by_min(min)
    if item == nil
      render json: ErrorSerializer.no_results_found, status: 400
    else
      ItemSerializer.new(item)
    end
  end

  def self.find_max_item(query_params)
    max = query_params[:max_price].to_f
    item = Item.find_by_max(max)
    if item == nil
      render json: ErrorSerializer.no_results_found, status: 400
    else
      ItemSerializer.new(item)
    end
  end

  def self.find_items_within_range(query_params)
    min = query_params[:min_price].to_f
    max = query_params[:max_price].to_f
    items = Item.find_min_max_item(min, max)
    if items == nil
      render json: ErrorSerializer.no_results_found, status: 400
    else
      ItemSerializer.new(items)
    end
  end


  private

  def query_params
    params.permit(:name, :min_price, :max_price)
  end
end
