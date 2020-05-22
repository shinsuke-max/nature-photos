require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  describe '#create' do

    context 'as an authorized user' do

      context 'with valid attributes' do
        it 'adds a like' do
          user = create(:user)
          post = create(:post, user_id: user.id)
          like = attributes_for(:like, post_id: post.id, user_id: user.id)
          sign_in user
          expect do
            post post_likes_path(post_id: post.id), params: { like: like }
          end.to change(user.likes, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a like' do
          user = create(:user)
          post = create(:post, user_id: user.id)
          like = attributes_for(:like, post_id: nil, user_id: nil)
          sign_in user
          expect do
            post post_likes_path(post_id: post.id), params: { like: like }
          end.to_not change(user.comments, :count)
        end
      end

    end

    context 'as an unauthorized user' do

      it 'does not add a like' do
        user = create(:user)
        other_user = create(:user)
        post = create(:post, user_id: user.id)
        like = attributes_for(:like, post_id: post.id, user_id: other_user.id)
        sign_in user
        expect do
          post post_likes_path(post_id: post.id), params: { like: like }
        end.to_not change(user.comments, :count)
      end

    end

    context 'as a guest' do
      it 'does not add a like' do
        user = create(:user)
        post = create(:post, user_id: user.id)
        like = attributes_for(:like, post_id: post.id, user_id: user.id)
        expect do
          post post_likes_path(post_id: post.id), params: { like: like }
        end.to_not change(user.comments, :count)
      end
    end
  end

  describe '#destroy' do

    context 'as an authorized user' do
      it 'deletes a like' do
        user = create(:user)
        post = create(:post, user_id: user.id)
        like = create(:like, user_id: user.id, post_id: post.id)
        sign_in user
        expect do
          delete post_like_path(post_id: post.id, id: like.id)
        end.to change(user.likes, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do

      it 'does not delete the like' do
        user = create(:user)
        other_user = create(:user)
        post = create(:post, user_id: user.id)
        like = create(:like, user_id: user.id, post_id: post.id)
        sign_in other_user
        expect do
          delete post_like_path(post_id: post.id, id: like.id)
        end.not_to change(user.likes, :count)
      end

      it 'redirects to the post_path' do
        user = create(:user)
        other_user = create(:user)
        post = create(:post, user_id: user.id)
        like = create(:like, user_id: user.id, post_id: post.id)
        sign_in other_user
        delete post_like_path(post_id: post.id, id: like.id)
        expect(response).to redirect_to post_path(post)
      end
    end

    context 'as a guest' do
      before do
        user = create(:user)
        @post = create(:post, user_id: user.id)
        @like = create(:like, user_id: user.id, post_id: @post.id)
      end

      it 'returns a 302 response' do
        delete post_like_path(post_id: @post.id, id: @like.id)
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete post_like_path(post_id: @post.id, id: @like.id)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not delete the post' do
        expect do
          delete post_like_path(post_id: @post.id, id: @like.id)
        end.not_to change(Like, :count)
      end
    end


  end
end
