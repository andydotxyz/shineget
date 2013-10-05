# encoding: utf-8
require 'nokogiri'
require 'open-uri'

class ListParser
  def self.parse(url_or_file, limit=0)

    @list = List.new
    @list.url = url_or_file

    doc = Nokogiri::HTML(open(url_or_file))

    @list.name = title_of_item doc
    urls = list_of_items(doc);
    @list.total = urls.count

    count = 0
    urls.each { |item|
      if count >= limit and limit != 0
        break
      end

      obj = ItemParser.parse(item)
      obj.list = @list

      @list.items << obj
      count += 1
    }

    return @list
  end

  def self.parse_sample(url_or_file)
    self.parse(url_or_file, 6)
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