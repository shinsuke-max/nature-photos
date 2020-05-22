require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user_id: user.id) }

  it 'has a valid factory' do
    expect(build(:comment)).to be_valid
  end

  it 'is valid a comment' do
    comment = Comment.new(post_id: post.id, user_id: user.id, comment: "hogehoge")
    comment.valid?
    expect(comment).to be_valid
  end

  it 'is invalid without a post_id' do
    comment = Comment.new(post_id: nil, user_id: user.id, comment: "hogehoge")
    comment.valid?
    expect(comment).not_to be_valid
  end

  it 'is invalid without a user_id' do
    comment = Comment.new(post_id: post.id, user_id: nil, comment: "hogehoge")
    comment.valid?
    expect(comment).not_to be_valid
  end

  it 'is invalid without a comment' do
    comment = Comment.new(post_id: post.id, user_id: user.id, comment: nil)
    comment.valid?
    expect(comment).not_to be_valid
  end

  it 'is invalid too long comment' do
    comment = Comment.new(post_id: post.id, user_id: user.id, comment: "a" * 200)
    comment.valid?
    expect(comment).not_to be_valid
  end
end
