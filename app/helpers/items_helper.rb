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

    if item.currentprice > item.price * 1.1
      'dearer'
    elsif item.currentprice < item.price * 0.9
      'cheaper'
    end
  end

  def price_delta(item)
    if !show_old_price?(item) || item.price == item.currentprice
      return ''
    end

    if item.currentprice < item.price
      drop = (((item.price - item.currentprice) / item.price) * 100)
      symbol = "\u2193".force_encoding('UTF-8')
    else
      drop = (((item.currentprice - item.price) / item.price) * 100)
      symbol = "\u2191".force_encoding('UTF-8')
    end

    return "%s%.2f%%" % [symbol, drop] if drop < 1
    return "%s%.1f%%" % [symbol, drop] if drop < 5
    "%s%.0f%%" % [symbol, drop]
  end

  def show_old_price?(item)
    if item.currentprice.nil?
      false
    else
      item.currentprice != item.price
    end
  end
end
