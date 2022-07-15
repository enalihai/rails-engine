module Parameterizer
class ItemFacade
  attr_reader :search

  def self.find_item_by_name(params)
    item = Item.find_item(params[:name])
    if item == nil
      return ErrorSerializer.no_results_found
    else
      ItemSerializer.new(item)
    end
  end

  def self.find_all_items_by_name(params)
    items = Item.find_all_items(params[:name])
    if items == nil
      return ErrorSerializer.no_results_found
    else
      ItemSerializer.new(items)
    end
  end

  def self.find_min_item(params)
    item = Item.find_by_min(params)
    if item == nil
      return ErrorSerializer.no_results_found
    else
      ItemSerializer.new(item)
    end
  end

  def self.find_max_item(max_price)
    item = Item.find_by_max(params)
    if item == nil
      return ErrorSerializer.no_results_found
    else
      ItemSerializer.new(item)
    end
  end

  def self.find_items_within_range(min_price, max_price)
  end

  def self.search(params)
    # binding.pry
    if params.has_key?(:name)
      find_item_by_name(params)
    elsif params.has_key?(:min_price) && !params.has_key?(:max_price)
      find_min_item(params)
    elsif !params.has_key?(:min_price) && params.has_key?(:max_price)
      find_max_item(params)
    elsif params.has_key?(:min_price) && params.has_key?(:max_price)
      binding.pry
      find_items_within_range(params[:min_price], params[:max_price])

      #whatever is left
    end
  end
  
end
