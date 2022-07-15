class ItemFacade
  include Parameterable

  def self.search(@params)
    if name_only?(@params)
      find_item_by_name(@params[:name])
    elsif just_min?(@params)
      find_min_item(@params[:min_price].to_f)
    elsif just_min?(@params)
      find_max_item(@params[:max_price].to_f)
    elsif min_to_max?(@params)
      find_items_within_range(@params[:min_price].to_f, @params[:max_price].to_f)
    else
      { data: { id: 'error', title: 'No results found on database' }, status: 400 }
    end
  end

  def name_only?(@params)
    return true if (@params[:name].present? && !@params[:min_price].present? && !@params[:min_price].present?)
  end

  def just_min?(@params)
    return true if !@params[:name].present? && @params[:min_price].present? && !@params[:max_price].present?
  end

  def just_max?(@params)
    return true if !@params[:name].present? && !@params[:min_price].present? && @params[:max_price].present?
  end

  def min_to_max(@params)
    return true if !@params[:name].present? && @params[:min_price].present? && @params[:max_price].present?
  end

  def self.find_item_by_name(name)
    item = Item.find_item(name)
    if item == nil
      { data: { id: 'error', title: 'No results found on database' }, status: 400 }
    else
      item
    end
  end

  def self.find_all_items_by_name(name)
    items = Item.find_all_items(name)
    if items == nil
      { data: { id: 'error', title: 'No results found on database' }, status: 400 }
    else
      items
    end
  end

  def self.find_min_item(min)
  binding.pry
    item = Item.find_by_min(min)
    if item == nil
      { data: { id: 'error', title: 'No results found on database' }, status: 400 }
    else
      item
    end
  end

  def self.find_max_item(max)
    item = Item.find_by_max(max)
    if item == nil
      { data: { id: 'error', title: 'No results found on database' }, status: 400 }
    else
      item
    end
  end

  def self.find_items_within_range(min, max)
    items = Item.find_min_max_item(min, max)
    if items == nil
      { data: { id: 'error', title: 'No results found on database' }, status: 400 }
    else
      items
    end
  end

  private
    def set_query_params
      params = {name: params[:name], min_price: params[:min_price], max_price: params[:max_price]}
    end

    def validate_params
      if valid_query?(@params) == false
        render json: ErrorSerializer.invalid_parameters#{ error: 'Invalid Parameters: cant be nil'}, status: 400
      end
    end
end
