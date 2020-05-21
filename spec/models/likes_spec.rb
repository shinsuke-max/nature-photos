require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user_id: user.id) }

  it 'has a valid factory' do
    expect(build(:like)).to be_valid
  end

  it 'is valid a like' do
    like = Like.new(post_id: post.id, user_id: user.id)
    like.valid?
    expect(like).to be_valid
  end

  it 'is invalid without a post_id' do
    like = Like.new(post_id: nil, user_id: user.id)
    like.valid?
    expect(like).to_not be_valid
  end

  it 'is invalid without a user_id' do
    like = Like.new(post_id: post.id, user_id: nil)
    like.valid?
    expect(like).to_not be_valid
  end

  it '同じユーザーが同じ投稿に複数回いいね！できない' do
    Like.create!(post_id: post.id, user_id: user.id)
    like = Like.new(post_id: post.id, user_id: user.id)
    like.valid?
    expect(like).to_not be_valid
  end
end
