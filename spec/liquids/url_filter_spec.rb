require 'spec_helper'

describe UrlFilter do

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  let(:iphone4) { Factory :iphone4, shop: shop }

  it 'should get asset_url' do
    variant = "{{ 'shop.css' | asset_url }}"
    params = { 'shop' => ShopDrop.new(shop) } # 不能使用 { shop: shop }，即key不能为symbol，否则会找不到shop对象
    Liquid::Template.parse(variant).render(params).should eql "/s/files/#{Rails.env}/#{shop.id}/theme/#{theme.id}/assets/shop.css"
  end

  it 'should get global_asset_url' do
    variant = "{{ 'textile.css' | global_asset_url }}"
    Liquid::Template.parse(variant).render.should eql '/s/global/textile.css'
  end

  it 'should get shopqi_asset_url' do
    variant = "{{ 'option_selection.js' | shopqi_asset_url }}"
    Liquid::Template.parse(variant).render.should eql '/s/shopqi/option_selection.js'
  end

  it 'should get product_img_url' do
    variant = "{{ product.photos.first | product_img_url: 'medium' }}"
    Liquid::Template.parse(variant).render('product' => ProductDrop.new(iphone4)).should eql '/assets/admin/no-image-medium.gif'
  end

  it "should get type url" do
    variant = "{{ product.type | link_to_type}}"
    result = "<a title=#{iphone4.product_type} href='/collections/types?q=#{iphone4.product_type}'>#{iphone4.product_type}</a>"
    Liquid::Template.parse(variant).render('product' => ProductDrop.new(iphone4)).should eql result
  end

  it "should get vendor url" do
    variant = "{{ vendor | link_to_vendor}}"
    result = "<a title=Cola href='/collections/vendors?q=Cola'>Cola</a>"
    Liquid::Template.parse(variant).render('vendor' => 'Cola').should eql result
  end

end
