class ItemFacade
  attr_reader :search

  def self.find_item_by_name(params)
    name = params[:name]
    item = Item.find_item(name)
    if item == nil
      return ErrorSerializer.no_results_found
    else
      ItemSerializer.new(item)
    end
  end

  def self.find_all_items_by_name(name)
    name = params[:name]
    items = Item.find_all_items(name)
    if items == nil || items == []
      return ErrorSerializer.no_results_found, status: 400
    else
      ItemSerializer.new(items)
    end
  end

  def self.find_min_item(params)
    min = params[:min_price].to_f
    item = Item.find_by_min(min)
    if item == nil
      return ErrorSerializer.no_results_found
    else
      ItemSerializer.new(item)
    end
  end

  def self.find_max_item(max_price)
    max = params[:max_price].to_f
    item = Item.find_by_max(max)
    if item == nil
      return ErrorSerializer.no_results_found
    else
      ItemSerializer.new(item)
    end
  end

  def self.find_items_within_range(min_price, max_price)
    min = params[:min_price].to_f
    max = params[:max_price].to_f
    items = Item.find_min_max_item(min, max)
    if items == nil
      return ErrorSerializer.no_results_found
    else
      ItemSerializer(items)
    end
  end

  def self.search(params)
    if params.has_key?(:name)
      find_item_by_name(params)
    elsif params.has_key?(:min_price) && !params.has_key?(:max_price)
      find_min_item(params)
    elsif !params.has_key?(:min_price) && params.has_key?(:max_price)
      find_max_item(params)
    elsif params.has_key?(:min_price) && params.has_key?(:max_price)
      find_items_within_range(params[:min_price], params[:max_price])
    else
      render json: {error: nil}, status: 400
    end
  end

  # def name_search
  #   name = params[:name]
  # end
  #
  # def min_price
  #   min_price = params[:min_price]
  # end
  #
  # def max_price
  #   max_price = params[:max_price]
  # end
  # def min_max_collection
  #   min_price = params[:min_price]
  #   max_price = params[:max_price]
  # end
end
