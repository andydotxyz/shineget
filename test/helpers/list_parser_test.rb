require 'test_helper'

class ItemParserTest < ActionView::TestCase

  test 'parsing an amazon list returns correct items' do
    list = ListParser.parse(File.dirname(__FILE__) + '/list-amazon.html', 'http://amazon.co.uk/')

    assert_equal 'A J E Williams', list.name
    assert_equal 18, list.items.size
  end

end
