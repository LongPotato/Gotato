# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Order.delete_all
Customer.delete_all

name_array = ['thuy duong', 'David The Penis', 'ashey pham', 'vu thuy linh', 'Dog', 'Very long name here', 
              'ho li fuk', 'lul', 'Chuthlu Da Savior', 'sum ting wong', 'le thi b', 'pham hong ngoc', 'nguyen van a', 'For Sale']

store_name = ['macy', 'express', 'michael kors', 'blooming dales', 'apple', 'bestbuy', 'LOFT', 'craiglist', 'ebay', 'Saks Fifth Avenue', 'Amazon', 'Kate Spade']

order_name = ['1 dong ho MK 2280', '11 cai vay size S LOFT #345', "1 tui PL size M Cobalt", '1 tui PL size S Elictric Blue', 
              '1 creamy white fishing sauce', '1 vay ', '1 do va 1 tui nude', '3 cai ao SAVANNAH CUTOUT SKATER DRESS', '2 lo glucosamine', '1 xe oto']

note_list = ['BI CANCEL', 've 9 cai, ship 7/17, 2 ship 7/21', "that bitch wants fast delivery but didn't deposit money",
            've 1 cai nhung ngu quen khong ship', 'for relative', 'de danh ban', "", "deposited", "chuyen tu inventory"]

image = ["http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2014/9/24/1411574454561/03085543-87de-47ab-a4eb-58e7e39d022e-620x372.jpeg", "", 
         "http://anf.scene7.com/is/image/anf/anf_86290_01_prod1?$productMagnify-anf$", "http://store.storeimages.cdn-apple.com/4662/as-images.apple.com/is/image/AppleInc/aos/published/images/w/38/w38ss/sbbk/w38ss-sbbk-sel_GEO_US?wid=332&hei=392&fmt=jpeg&qlt=95&op_sharpen=0&resMode=bicub&op_usm=0.5,0.5,0,0&iccEmbed=0&layer=comp&.v=1428609306485",
         "http://dailycaller.com/wp-content/uploads/2012/06/fat-guy-on-scooter-e1340397639649.jpg"]

web_id = ["159", "TFE", "1460", "E342", "DS160", "123", "342", "3253", "MNOP3", "I20"]

vn_price = [500000, 1000000, 10050040, 230000, 45500, 3530000, 100000, 36000000, 52000000, 3421200]

price_list = [3.99, 345.99, 45, 10.50, 0, 10500, 1400, 860, 640.99, 150, 40.50, 79.99, 83.40]

customer_array = []

time = [Time.now, 2.days.from_now, 2.days.from_now, nil]

true_false = [true, false]

50.times do
  rand_name = name_array[rand(0..12)]
  new_customer = Customer.create(name: rand_name)
  customer_array << new_customer.id
end

100.times do
  s = rand(100)
  quan = rand(1..20)
  price = price_list[rand(0..12)]
  vn = vn_price[rand(0..10)]
  tax = (price * 0.08).round(2)
  reward = (price * 0.01).round(2)
  deposit = (vn.to_f * 0.1).round(2)
  total = price + tax + quan - reward
  profit = vn.to_f - (total * 21000)
  Order.create(description: order_name[rand(0..9)], note: note_list[rand(0..8)], received_us: true_false[rand(0..1)],
               store: store_name[rand(0..11)], image_link: image[rand(0..4)], 
               order_date: time[rand(0..3)], ship_vn: time[rand(0..3)], web_order_id: "#{web_id[rand(0..9)]}-#{web_id[rand(0..9)]}-#{web_id[rand(0..9)]}",
               web_price: price, tax: tax, shipping_us: quan, reward: (price * 0.01).round(2), total: total.round(2), total_cost: (total * 2100).round(2),
               profit: profit.round(2), vnd: 21000, deposit: deposit, selling_price: vn, user_id: 1, customer_id: customer_array[rand(customer_array.size) - 1])
end









