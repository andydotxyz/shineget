# encoding: utf-8
require 'nokogiri'
require 'open-uri'

class ItemParser
  def self.parse(url)

    @item = Item.create
    @item.url = url

    if url[0..3] == 'file'
      url = url[7..-1]
    end

    doc = Nokogiri::HTML(open(url))

    @item.title = title_of_item doc
    @item.imgurl = image_of_item doc
    @item.price = price_of_item doc

    return @item
  end

  private
    def self.title_of_item(doc)
      if doc.at_css('h1')
        return doc.at_css('h1').text.strip
      end
      return doc.title.strip
    end

    def self.image_of_item(doc)
      images = doc.xpath('//img').select{|image| is_item_image image}
      if images
        return images[0]['src']
      end
      return nil
    end

    def self.is_item_image(image)
      if image.attribute("src").to_s.scan(/icon|CSS|currency|sprite|pixel/i).present?
        return false
      end
      if image.attribute('id').to_s.scan(/logo/).present?
        return false
      end

      if image.attribute('style').to_s.scan(/display:none/).present?
        return image.parent.attribute('id').to_s == 'rwImages_hidden'
      end

      return true
    end

    def self.price_of_item(doc)
      # look for prices in things marked as class="text"
      doc.css('.price').each do |node|
        if node.parent.parent.attribute('id').to_s == 'secondaryUsedAndNew'
          break
        end

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
        return text.match(/(\d+[,.]\d+)/).to_s.to_f
      end
      return 0.0
    end
end