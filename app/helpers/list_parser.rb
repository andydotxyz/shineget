# encoding: utf-8
require 'nokogiri'
require 'open-uri'

class ListParser
  def self.parse(url_or_file)

    @list = List.new
    @list.url = url_or_file

    doc = Nokogiri::HTML(open(url_or_file))

    @list.name = title_of_item doc

    list_of_items(doc).each { |item|
      obj = ItemParser.parse(item)
      obj.list = @list
      @list.items << obj
    }

    return @list
  end

  private
    def self.title_of_item(doc)
      if doc.at_css('h1')
        return doc.title.strip + ' - ' + doc.at_css('h1').text.strip
      end
      return doc.title.strip
    end

    def self.list_of_items(doc)
      items = []
      # amazon.co.uk
      doc.xpath('//*[@class="productImage"]/a/@href').each { |href| items.append href.value }
      return items
    end
end