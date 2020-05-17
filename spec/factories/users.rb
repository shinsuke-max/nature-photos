# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Testman' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
  end
end
