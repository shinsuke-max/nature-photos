# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe '#index' do
    it 'responds successfully' do
      get posts_path
      expect(response).to be_success
    end

    it 'returns a 200 response' do
      get posts_path
      expect(response).to have_http_status '200'
    end
  end

  describe 'new' do
    context 'as an authorized user' do
      it 'responds successfully' do
        user = create(:user)
        sign_in user
        get new_post_path
        expect(response).to be_success
      end
    end

    context 'as a guest' do
      it 'redirects to the sign_in page' do
        get new_post_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#show' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @post = create(:post, user_id: @user.id)
      end

      it 'responds successfully' do
        sign_in @user
        get post_path(id: @post.id)
        expect(response).to be_success
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @post = create(:post, user_id: other_user.id)
      end

      it 'responds successfully' do
        sign_in @user
        get post_path(id: @post.id)
        expect(response).to be_success
      end
    end
  end

  describe '#edit' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @post = create(:post, user_id: @user.id)
      end

      it 'responds successfully' do
        sign_in @user
        get edit_post_path(id: @post.id)
        expect(response).to be_success
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @post = create(:post, user_id: other_user.id)
      end

      it 'responds successfully' do
        sign_in @user
        get edit_post_path(id: @post.id)
        expect(response).to be_success
      end
    end

    context 'as a guest' do
      before do
        user  = create(:user)
        @post = create(:post, user_id: user.id)
      end

      it 'returns a 302 response' do
        get edit_post_path(id: @post.id)
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        get edit_post_path(id: @post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before do
        @user = create(:user)
      end

      context 'with valid attributes' do
        it 'adds a post' do
          post = attributes_for(:post)
          sign_in @user
          expect do
            post posts_path, params: { post: post }
          end.to change(@user.posts, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a post' do
          post = attributes_for(:post, content: nil)
          sign_in @user
          expect do
            post posts_path, params: { post: post }
          end.not_to change(@user.posts, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        post = attributes_for(:post)
        post posts_path, params: { post: post }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        post = attributes_for(:post)
        post posts_path, params: { post: post }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @post = create(:post, user_id: @user.id)
      end

      it 'updates a post' do
        post = attributes_for(:post, content: 'Update Post yeah!')
        sign_in @user
        patch post_path(@post), params: { post: post }
        expect(@post.reload.content).to eq 'Update Post yeah!'
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @post = create(:post, user_id: other_user.id, content: 'Test Update')
      end

      it 'does not update the post' do
        post = attributes_for(:post, content: 'Update yes yes yes!')
        sign_in @user
        patch post_path(@post), params: { post: post }
        expect(@post.reload.content).to eq 'Test Update'
      end

      it 'redirects to the post#show' do
        post = attributes_for(:post, content: 'Update yes yes yes!')
        sign_in @user
        patch post_path(@post), params: { post: post }
        expect(response).to redirect_to post_path(@post)
      end
    end

    context 'as a guest' do
      before do
        user = create(:user)
        @post = create(:post, user_id: user.id)
      end

      it 'returns a 302 response' do
        post = attributes_for(:post)
        patch post_path(@post), params: { post: post }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        post = attributes_for(:post)
        patch post_path(@post), params: { post: post }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#destroy' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @post = create(:post, user_id: @user.id)
      end

      it 'deletes a post' do
        sign_in @user
        expect do
          delete post_path(@post)
        end.to change(@user.posts, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @post = create(:post, user_id: other_user.id)
      end

      it 'does not delete the post' do
        sign_in @user
        expect do
          delete post_path(@post)
        end.not_to change(Post, :count)
      end

      it 'redirects to the post_path' do
        sign_in @user
        delete post_path(@post)
        expect(response).to redirect_to root_path
      end
    end

    context 'as a guest' do
      before do
        user = create(:user)
        @post = create(:post, user_id: user.id)
      end

      it 'returns a 302 response' do
        delete post_path(@post)
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete post_path(@post)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not delete the post' do
        expect do
          delete post_path(@post)
        end.not_to change(Post, :count)
      end
    end
  end
end
