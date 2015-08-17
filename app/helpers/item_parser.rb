# encoding: utf-8
require 'nokogiri'
require 'open-uri'

class ItemParser
  def self.parse(url_or_file)

    @item = Item.new
    @item.url = url_or_file

    doc = Nokogiri::HTML(open(url_or_file))

    @item.title = title_of_item doc
    @item.imgurl = image_of_item doc
    @item.price = price_of_item doc
    @item.currentprice = @item.price

    return @item
  end

  def self.update_price(item)
    new_item = self.parse(item.url)

    if item.currentprice != new_item.price
      puts 'Updated ' + item.title + ' to ' + new_item.price.to_s
      item.currentprice = new_item.price
      item.save
    end
  end

  private
    def self.title_of_item(doc)
      h1s = doc.xpath('//h1')
      return h1s[0].text.strip if h1s.count > 0 and h1s[0].text.strip.length > 0
      return h1s[1].text.strip if h1s.count > 1 and h1s[1].text.strip.length > 0

      return doc.css('#productTitle').text.strip if doc.css('#productTitle').present?
      return doc.title.strip if doc.title
      return ""
    end

    def self.image_of_item(doc)
      image = doc.css('#main-image-container img')
      return image.attribute('src').to_s if image.present?
      image = doc.css('img#product-zoomview')
      return image.attribute('src').to_s if image.present?

      image = doc.xpath('//img[@id="mainimage"]')
      return 'http://www.argos.co.uk' + image.attribute('src').to_s if image.present?

      node = doc.xpath('//*[@data-large-image-href]')
      return node.attribute('data-large-image-href').to_s if node.present?

      images = doc.xpath('//img').select{|image| is_item_image image}

      if images && images.count > 0
        return sanitise_url images[0]['src']
      end
      return nil
    end

    def self.is_item_image(image)
      if image.attribute('id').to_s.scan(/productImage/i).present?
        return true
      end
      if image.attribute('class').to_s.scan(/data-image|main-image/i).present?
        return true
      end

      if image.attribute('id').to_s.scan(/logo|zoom/i).present?
        return false
      end
      if image.attribute("src").to_s.scan(/icon|CSS|currency|sprite|common|banners|pixel|logo|adserver/i).present?
        return false
      end
      if image.attribute('alt').to_s.scan(/deals/i).present?
        return false
      end

      if image.attribute('style').to_s.include? 'display:none'
        return image.parent.attribute('id').to_s == 'rwImages_hidden'
      end

      if image.parent.parent.parent.attribute('class').to_s.include?'brand' or
          image.parent.parent.parent.attribute('class').to_s.include?'thumbnail' or
          image.parent.parent.attribute('class').to_s.include?'brand'
        return false
      end

      return true
    end

    def self.sanitise_url(url)
      if url[0..1] == '//'
        return 'http:' + url
      end

      return url;
    end

    def self.price_of_item(doc)
      # look in headers
      doc.xpath("//meta[@property='og:price:amount']/@content").each do |attr|
        return price_in_text attr.value if attr.value
      end

      # then look for prices in things marked as prices in the class
      doc.css('#priceblock_ourprice').each do |node|
        price = price_in_text node.text
        if price > 0.0
          return price
        end
      end
      doc.css('.priceLarge').each do |node|
        price = price_in_text node.text
        if price > 0.0
          return price
        end
      end
      doc.css('.product-price').each do |node|
        price = price_in_text node.text
        if price > 0.0
          return price
        end
      end
      doc.css('.currency-value').each do |node|
        if node.parent.attribute('class').to_s.start_with?'shipping'
          next
        end

        price = price_in_text node.text
        if price > 0.0
          return price
        end
      end

      doc.css('.price').each do |node|
        if node.parent.parent.attribute('id').to_s == 'secondaryUsedAndNew' or node.parent.attribute('class').to_s.scan(/delivery-|SavePrice/i).present?
          next
        end

        price = price_in_text node.text
        if price > 0.0
          return price
        end
      end

      # search for prices in each paragraph
      price = price_in_type('p', doc)
      if price > 0.0
        return price
      end

      # search for prices in each span
      return price_in_type('span', doc)
    end

    def self.price_in_type(type, doc)
      price_text = doc.xpath('//' + type + '[contains(text(), \'£\') or contains(text(), \'&pound;\') or contains(text(), \'&#163;\')]')
      if price_text.nil? || price_text.blank?
        return 0.0
      end

      if price_text.attribute('class') && price_text.attribute('class').to_s.scan(/Shipping/i).present?
        return 0.0
      end
      return price_in_text price_text.text
    end

    def self.price_in_text(text)
      if text
        # bear in mind that internationally this will not work
        return text.match(/(\d+[,.]\d+)/).to_s.tr(',', '').to_f
      end
      return 0.0
    end
end