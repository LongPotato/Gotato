# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Order.delete_all
Customer.delete_all

name_array = ['Bob', 'David Bowie', 'Ashley', 'Cat', 'Dog', 'Verylongnamehere', 
              'Megatron', 'lul', 'Chuthlu Da Savior', 'Alex', 'Aaron', 'Batman', 'Spoodermon']
customer_array = []

5.times do
  rand_name = name_array[rand(0..12)]
  new_customer = Customer.create(name: rand_name)
  customer_array << new_customer.id
end

20.times do
  s = rand(100)
  quan = rand(20)
  Order.create(name: "RandomOrder_#{s}", quantity: quan, description: "Very good", note: "#{quan} items", 
               store: "Store ##{s}", image_link: "http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2014/9/24/1411574454561/03085543-87de-47ab-a4eb-58e7e39d022e-620x372.jpeg", 
               order_date: Time.now, receive_us: 2.days.from_now, ship_vn: 3.days.from_now, 
               web_price: 24.55, tax: 10.41, shipping_us: quan, reward: 3.25, 
               vnd: 21000, deposit: 100500, selling_price: 10000000, user_id: 2, customer_id: customer_array[rand(customer_array.size) - 1])
end