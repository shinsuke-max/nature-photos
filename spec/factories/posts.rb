FactoryBot.define do
  factory :post do
    content { "testtest" }
    user_id { "1" }
    image   { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/sample.jpg'), 'image/jpg') }
  end
end
