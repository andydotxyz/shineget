module ItemsHelper
  def buy_url(item)
    (item_url item).to_s + '/buy'
  end

  def has_price?(item)
    item.price and item.price != 0
  end

  def current_price(item)
    if item.currentprice and item.currentprice != 0
      item.currentprice
    else
      item.price
    end
  end

  def css_class_for_current_price(item)
    if item.currentprice.nil? or item.currentprice == item.price
      return ''
    end

    if item.currentprice > item.price
      'dearer'
    else
      'cheaper'
    end
  end

  def show_old_price?(item)
    if item.currentprice.nil?
      false
    else
      item.currentprice != item.price
    end
  end
end
