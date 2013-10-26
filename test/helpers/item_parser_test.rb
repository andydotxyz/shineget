require 'test_helper'

class ItemParserTest < ActionView::TestCase

  def run_data_tests(file, data)
    item = ItemParser.parse(File.dirname(__FILE__) + '/' + file + '.html')

    assert_equal item.title, data[:title]
    assert_equal item.imgurl, data[:imgurl]
    assert_equal item.price, data[:price]
  end

  test 'parsing provided html gets basic data' do
    run_data_tests( 'test',
                    :title => 'Test Title',
                    :imgurl => 'http://example.com/test.png',
                    :price => 20.00 )
  end

  test 'parsing provided html gets contextual data' do
    run_data_tests( 'test2',
                    :title=> 'Overridden Title',
                    :imgurl => 'http://example.com/test.png',
                    :price => 24.99 )
  end

  test 'parsing real tshirt html gets correct data' do
    run_data_tests( 'tshirt',
                    :title => 'Men\'s Zelda Nintendo With Link T-Shirt (Black)',
                    :imgurl => 'http://p.playserver1.com/ProductImages/0/3/5/9/5/2/9/3/39259530_300x300_1.jpg',
                    :price => 16.99 )
  end

  test 'parsing real screwdriver html gets correct data' do
    run_data_tests( 'screwdriver',
                    :title => 'Tenth Doctor\'s Sonic Screwdriver Universal Remote Control',
                    :imgurl => 'http://media.firebox.com/pic/p6153_column_grid_6.jpg',
                    :price => 69.95 )
  end

  test 'parsing real screwdriver-us html gets correct data' do
    run_data_tests( 'screwdriver-us',
                    :title => 'Tenth Doctor\'s Sonic Screwdriver Universal Remote Control',
                    :imgurl => 'http://media.firebox.com/pic/p6153_column_grid_6.jpg',
                    :price => 69.95 )
  end

  test 'parsing real technic html gets correct data' do
    run_data_tests( 'technic',
                    :title => 'LEGO Technic 8110 Mercedes-Benz Unimog U 400',
                    :imgurl => 'http://ecx.images-amazon.com/images/I/51B1clwfANL._SY300_.jpg',
                    :price => 126.99 )
  end

  test 'parsing real appletv html gets correct data' do
    run_data_tests( 'appletv',
                    :title => 'New Apple TV with 1080p Full HD',
                    :imgurl => 'http://johnlewis.scene7.com/is/image/JohnLewis/231055719?$prod_main$',
                    :price => 99.0 )
  end

  test 'parsing real despicable html gets correct data' do
    run_data_tests( 'despicable',
                    :title => 'Despicable Me 2 [DVD + UV Copy] [2013]',
                    :imgurl => 'http://ecx.images-amazon.com/images/I/51AqXLIsGSL._SY300_.jpg',
                    :price => 10.0 )
  end

  test 'parsing real starwars html gets correct data' do
    run_data_tests( 'starwars',
                    :title => 'Star Wars Origami',
                    :imgurl => 'http://media.firebox.com/pic/p5546_column_grid_6.jpg',
                    :price => 12.99 )
  end

  test 'parsing real knex html gets correct data' do
    run_data_tests( 'knex',
                    :title => 'K\'Nex Mario Vs Goombas Building Set',
                    :imgurl => 'http://static.toysrus.co.uk//medias/sys_master/h29/hb4/8810489217054.jpg',
                    :price => 34.99 )
  end

  test 'parsing real lego html gets correct data' do
    run_data_tests( 'delorean',
                    :title => 'The DeLorean time machine',
                    :imgurl => 'http://cache.lego.com/e/dynamic/is/image/LEGO/21103?$main$',
                    :price => 34.99 )
  end

  test 'parsing real argos html gets correct data' do
    run_data_tests( 'argos',
                    :title => 'Hornby Virgin Trains Pendolino 00 Gauge Train Set.',
                    :imgurl => 'http://www.argos.co.uk/wcsstore/argos/images/541-4623184IEUC1208071M.jpg',
                    :price => 130.00 )
  end

  test 'parsing real etsy html gets correct data' do
    run_data_tests( 'etsy',
                    :title => 'Retro Apron - Ms. Mouse Sexy Womans Aprons - Vintage Apron Style - Polka Dots Pin up Sweetheart Rockabilly Cosplay',
                    :imgurl => 'http://img0.etsystatic.com/037/0/5347629/il_570xN.513126640_7x0m.jpg',
                    :price => 53.97 )
  end
end
