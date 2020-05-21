FactoryBot.define do
  factory :comment do
    comment { 'testtest' }
    association :user
    association :post
  end
end
