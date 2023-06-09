require 'faker'

User.destroy_all
Item.delete_all
Order.destroy_all
OrderItem.destroy_all
CartItem.destroy_all


#10.times do
#  Item.create(
#    title: Faker::Commerce.product_name,
#    description: Faker::Lorem.paragraph,
#    price: "%.2f"%rand(0.0..100.0),
#    image_url: "https://loremflickr.com/#{rand(290..300)}/#{rand(290..300)}/kitten"
#  )
#end
s3 = Aws::S3::Resource.new(
  region: 'eu-west-3', # change this to your AWS region
  access_key_id: ENV['AMAZON_ACCESS_KEY_ID'],
  secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY']
)

bucket = s3.bucket('grgb') # change this to your bucket name

titles = [
  'Magnifique chaton unique',
  'Un chaton nommé Raymond',
  'Attention au camion pauvre chaton',
  'Chaton bien mignon...',
  'Bien plus qu\'un chaton',
  'Ce chaton sort de prison',
  'Chaton tueur de hannetons',
  'Chaton qui tourne pas rond',
  'Il peut aussi jouer du violon ce chaton',
  'C\'est rien c\'est juste un chaton'
]

10.times do
  item = Item.create(
    title: titles.shift,
    description: Faker::Lorem.paragraph,
    price: "%.2f"%rand(0.0..100.0),
  )

  # Create a temporary local image file
  image_file_path = "/tmp/#{SecureRandom.uuid}.jpg"
  open(image_file_path, 'wb') do |file|
    file << URI.open("https://loremflickr.com/#{rand(290..300)}/#{rand(290..300)}/kitten").read
  end

  # Upload the image to S3
  image_name = "item_#{SecureRandom.uuid}.jpg"
  obj = bucket.object(image_name)
  obj.upload_file(image_file_path)

  # Attach the image to the item
  item.image.attach(
    io: File.open(image_file_path),
    filename: image_name,
    content_type: 'image/jpg'
  )

  # Delete the temporary local image file
  File.delete(image_file_path) if File.exist?(image_file_path)
end



10.times do
  user = User.create(
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
  Cart.create(user_id: user.id)
end



Cart.all.each do |cart|
  rand(1..5).times do
    item = Item.all.sample
    CartItem.create(cart_id: cart.id, item_id: item.id)
  end
end


# 10.times do
#   user = User.all.sample
#   order = Order.create(user_id: user.id)
#   rand(1..5).times do
#     item = Item.all.sample
#     OrderItem.create(order_id: order.id, item_id: item.id)
#   end
# end
