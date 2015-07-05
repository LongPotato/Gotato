# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Order.delete_all
Customer.delete_all

name_array = ['donald duck', 'David The Penis', 'filet miyon', 'jame b grossweiner', 'Dog', 'Very long name here', 
              'ho li fuk', 'lul', 'Chuthlu Da Savior', 'sum ting wong', 'tiny cox', 'Batman', 'Spoodermon']

store_name = ['macy', 'express', 'michael kors', 'blooming dales', 'apple', 'bestbuy', 'walmart', 'craiglist', 'ebay', 'Saks Fifth Avenue']

order_name = ['Urinal', 'da sound machince', "Another long orderrrrr", 'ugly shirt', 'creamy white fishing sauce', 'negerito', 'plopp']

note_list = ['Very gooddddddddddddddddddddddddddd', 'lul this suck', "that bitch wants a fast delivery but she doesn't even want to deposit money",
            'this product is very goodddddddddddddddddddddddd', 'for relative', '4 items', "", "deposited", "from inventory"]

image = ["http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2014/9/24/1411574454561/03085543-87de-47ab-a4eb-58e7e39d022e-620x372.jpeg", ""]

vn_price = [500000, 1000000, 10050040, 230000, 45500, 3530000, 100000, 36000000, 52000000, 3421200, 3000]

price_list = [3.99, 345.99, 45, 10.50, 0, 10500, 1400, 860, 640.99, 150, 40.50, 79.99, 83.40]
customer_array = []

5.times do
  rand_name = name_array[rand(0..12)]
  new_customer = Customer.create(name: rand_name)
  customer_array << new_customer.id
end

20.times do
  s = rand(100)
  quan = rand(1..20)
  price = price_list[rand(0..12)]
  vn = vn_price[rand(0..10)]
  Order.create(name: order_name[rand(0..6)], quantity: quan, description: note_list[rand(0..8)], note: note_list[rand(0..8)], 
               store: store_name[rand(0..9)], image_link: image[rand(0..1)], 
               order_date: Time.now, receive_us: 2.days.from_now, ship_vn: 3.days.from_now, 
               web_price: price, tax: (price * 0.08).round(2), shipping_us: quan, reward: (price * 0.01).round(2), 
               vnd: 21000, deposit: (vn * 0.1).round(2), selling_price: vn, user_id: 1, customer_id: customer_array[rand(customer_array.size) - 1])
end