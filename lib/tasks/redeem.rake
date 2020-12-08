namespace :redeem do
  desc 'List redeem product'
  task :export_redeem_data, [] => :environment do |t, args|
    items = Redeem::RedeemProductItem.all.group_by{ |p| [p.product_id, p.size_id, p.color_id] }
    items_hash = {}
    items.each do |k, v|
      items_hash.merge! ({ k => v.count })
    end

    colors = Redeem::RedeemProductColor.pluck(:id, :name)
    colors_hash = {}
    colors.each do |id, name|
      colors_hash.merge!({ id => name })
    end

    sizes = Redeem::RedeemProductSize.pluck(:id, :name)
    sizes_hash = {}
    sizes.each do |id, name|
      sizes_hash.merge!({ id => name })
    end

    products_hash = {}
    products = Redeem::RedeemProduct.pluck(:id, :name, :price, :code)

    products.each do |product|
      products_hash.merge! ({ product[0] => {name: product[1], price: product[2].to_i, code: product[3] }})
    end

    headers = [ 'STT', 'Sản phẩm', 'Mã sản phẩm', 'Size', 'Màu sắc', 'Giá', 'Số lượng']

    products_csv = CSV.generate(headers: true) do |csv|
      csv << headers
      index = 0

      items_hash.each do |item, count|
        index += 1
        product_id = item[0]
        size_id = item[1]
        color_id = item[2]

        csv << [
          index,
          products_hash[product_id][:name],
          products_hash[product_id][:code],
          sizes_hash[size_id],
          colors_hash[color_id],
          products_hash[product_id][:price],
          count
        ]
      end
    end

    File.open("redeem_product_#{ Time.now.to_i }.csv", "w+") do |f|
      f.write(products_csv.force_encoding('iso-8859-1').encode('utf-8').encode("iso-8859-1").force_encoding("utf-8"))
    end
  end
end
