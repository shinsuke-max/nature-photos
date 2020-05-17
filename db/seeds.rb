# frozen_string_literal: true

User.create!(name: 'Example User',
             email: 'example@sample.org',
             password: 'foobar',
             password_confirmation: 'foobar')

User.create!(name: 'テストユーザー',
             email: 'test@example.com',
             password: 'testtest',
             password_confirmation: 'testtest')

# post = Post.new(content: "きれいなけしき！",
# user_id: "2")
# post.image.attach(io: File.open(Rails.root.join('app/assets/images/pic1.jpg')), filename: 'pic1.jpg')
# post.save

12.times do |n|
  name  = Faker::Games::Pokemon.name
  email = "example-#{n + 1}@sample.org"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

11.times do |p|
  content = Faker::Alphanumeric.alphanumeric(number: 10)
  post = Post.new(
    content: content,
    user_id: (p + 1).to_s
  )
  post.image.attach(io: File.open(Rails.root.join("app/assets/images/seed/image-#{p + 1}.jpg")), filename: "image-#{p + 1}.jpg")
  post.save!
end
