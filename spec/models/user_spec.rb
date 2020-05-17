# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is valid with a name, email and password' do
    user = User.new(
      name: 'hogehoge',
      email: 'tester@example.com',
      password: 'password'
    )
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include('を入力してください')
  end

  it 'is invalid without an email address' do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include('を入力してください')
  end

  it 'is invalid with a duplicate email address' do
    User.create!(
      name: 'Tester',
      email: 'tester@example.com',
      password: 'password'
    )
    user = User.new(
      name: 'Tester',
      email: 'tester@example.com',
      password: 'password'
    )
    user.valid?
    expect(user.errors[:email]).to include('はすでに存在します')
  end
end
