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

  test 'parsing real tshirt html gets correct data' do
    item = ItemParser.parse('file://' + File.dirname(__FILE__) + '/tshirt.html')

    assert_equal 'Men\'s Zelda Nintendo With Link T-Shirt (Black)', item.title
    assert_equal 'http://p.playserver1.com/ProductImages/0/3/5/9/5/2/9/3/39259530_300x300_1.jpg', item.imgurl
    assert_equal 16.99, item.price
  end

  test 'parsing real screwdriver html gets correct data' do
    item = ItemParser.parse('file://' + File.dirname(__FILE__) + '/screwdriver.html')

    assert_equal 'Tenth Doctor\'s Sonic Screwdriver Universal Remote Control', item.title
    assert_equal 'http://media.firebox.com/pic/p6153_column_grid_6.jpg', item.imgurl
    assert_equal 69.95, item.price
  end

  test 'parsing real technic html gets correct data' do
    item = ItemParser.parse('file://' + File.dirname(__FILE__) + '/technic.html')

    assert_equal 'LEGO Technic 8110 Mercedes-Benz Unimog U 400', item.title
    assert_equal 'http://ecx.images-amazon.com/images/I/51B1clwfANL._SY300_.jpg', item.imgurl
    assert_equal 126.99, item.price
  end
end
