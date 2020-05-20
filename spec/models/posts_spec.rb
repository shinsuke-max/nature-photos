# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) { create(:user) }

  it 'has a valid factory' do
    expect(build(:post, user_id: user.id)).to be_valid
  end

  it 'is invalid without a content' do
    post = build(:post, content: nil)
    post.valid?
    expect(post.errors[:content]).to include('を入力してください')
  end

  it 'is invalid too long content' do
    post = build(:post, content: "a" * 256)
    post.valid?
    expect(post.errors[:content]).to include('は140文字以内で入力してください')
  end
end
