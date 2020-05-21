# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    content { 'testtest' }
    association :user
    image   do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, 'spec/fixtures/sample.jpg'), 'image/jpg'
      )
    end
  end
end
