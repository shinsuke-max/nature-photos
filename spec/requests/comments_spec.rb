require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe '#create' do
    before do
      @user = create(:user)
      @post = create(:post)
    end

    context 'as an authorized user' do

      before { sign_in @user }

      context 'with valid attributes' do
        it 'adds a comment' do
          comment = attributes_for(:comment, post_id: @post.id, user_id: @user.id)
          expect do
            post post_comments_path(post_id: @post.id), params: { comment: comment }
          end.to change(@user.comments, :count).by(1)
        end
      end


      context 'with invalid attributes' do
        it 'does not add a comment' do
          comment = attributes_for(:comment, comment: nil, post_id: @post.id, user_id: @user.id)
          expect do
            post post_comments_path(post_id: @post.id),
              params: { comment: comment }
          end.to_not change(@user.comments, :count)
        end
      end
    end

    context 'as an unauthorized user' do
      it 'does not add a comment' do
        other_user = create(:user)
        comment = attributes_for(:comment, post_id: @post.id, user_id: other_user.id)
        sign_in @user
        expect do
          post post_comments_path(post_id: @post.id),
            params: { comment: comment }
        end.to_not change(@user.comments, :count)
      end
    end

    context 'as a guest' do
      it 'does not add a comment' do
        comment = attributes_for(:comment, post_id: @post.id, user_id: @user.id)
        expect do
          post post_comments_path(post_id: @post.id), params: { comment: comment }
        end.to_not change(@user.comments, :count)
      end
    end

  end

  describe '#update' do
    let(:user)           { create(:user) }
    let(:other_user)     { create(:user) }
    let(:post)           { create(:post) }
    let(:comment)        { create(:comment, post_id: post.id, user_id: user.id) }
    let(:update_comment) { attributes_for(:comment, comment: 'Update Comment!!!') }

    context 'as an authorized user' do
      it 'updates a comment' do
        sign_in user
        patch post_comment_path(post_id: post.id, id: comment.id), params: { comment: update_comment }
        expect(comment.reload.comment).to eq 'Update Comment!!!'
      end
    end

    context 'as an unauthorized user' do
      it 'does not update a comment' do
        sign_in other_user
        patch post_comment_path(post_id: post.id, id: comment.id), params: { comment: update_comment }
        expect(comment.reload.comment).to eq 'testtest'
      end
    end

    context 'as a guest' do
      before do
        patch post_comment_path(post_id: post.id, id: comment.id), params: { comment: update_comment }
      end

      it 'does not update a comment' do
        expect(comment.reload.comment).to eq 'testtest'
      end

      it 'returns a 302 response' do
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign_in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe '#edit' do
    let(:user)           { create(:user) }
    let(:other_user)     { create(:user) }
    let(:post)           { create(:post) }
    let(:comment)        { create(:comment, post_id: post.id, user_id: user.id) }
    let(:other_comment)  { create(:comment, post_id: post.id, user_id: other_user.id)}

    context 'as an authorized user' do
      it 'responds successfully' do
        sign_in user
        get edit_post_comment_path(post_id: post.id, id: comment.id)
        expect(response).to be_success
      end
    end

    context 'as an unauthorized user' do
      before do
        sign_in user
        get edit_post_comment_path(post_id: post.id, id: other_comment.id)
      end

      it 'returns a 302 response' do
        expect(response).to have_http_status '302'
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'as a guest' do
      before { get edit_post_comment_path(post_id: post.id, id: other_comment.id) }

      it 'returns a 302 response' do
        expect(response).to have_http_status '302'
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe '#destroy' do
    let(:user)           { create(:user) }
    let!(:other_user)     { create(:user) }
    let!(:post)          { create(:post) }
    let!(:comment)       { create(:comment, post_id: post.id, user_id: user.id) }
    let!(:other_comment)  { create(:comment, post_id: post.id, user_id: other_user.id)}

    context 'as an authorized user' do

      it 'deletes a comment' do
        sign_in user
        expect do
          delete post_comment_path(post_id: post.id, id: comment.id)
        end.to change(user.comments, :count).by(-1)
      end

    end

    context 'as an unauthorized user' do

      before { sign_in user }
      
      it 'does not delete the comment' do
        expect do
          delete post_comment_path(post_id: post.id, id: other_comment.id)
        end.not_to change(Comment, :count)
      end

      it 'redirects to the root_path' do
        delete post_comment_path(post_id: post.id, id: other_comment.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'as a guest' do
      before do
        delete post_comment_path(post_id: post.id, id: comment.id)
      end

      it 'returns a 302 response' do
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not delete the comment' do
        expect do
          delete post_comment_path(post_id: post.id, id: comment.id)
        end.not_to change(Comment, :count)
      end
    end
  end
end
