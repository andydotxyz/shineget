require 'test_helper'

class ItemParserTest < ActionView::TestCase
  test 'parsing provided html gets basic data' do
    item = ItemParser.parse('file://' + File.dirname(__FILE__) + '/test.html')

    assert_equal 'Test Title', item.title
    assert_equal 'http://example.com/test.png', item.imgurl
    assert_equal 20.00, item.price
  end

  test 'parsing provided html gets contextual data' do
    item = ItemParser.parse('file://' + File.dirname(__FILE__) + '/test2.html')

    assert_equal 'Overridden Title', item.title
    assert_equal 'http://example.com/test.png', item.imgurl
    assert_equal 24.99, item.price
  end

  test 'parsing real life html gets correct data' do
    item = ItemParser.parse('file://' + File.dirname(__FILE__) + '/tshirt.html')

    assert_equal 'Men\'s Zelda Nintendo With Link T-Shirt (Black)', item.title
    assert_equal 'http://p.playserver1.com/ProductImages/0/3/5/9/5/2/9/3/39259530_300x300_1.jpg', item.imgurl
    assert_equal 16.99, item.price
  end
end
