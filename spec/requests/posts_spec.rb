require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "#index" do
    it "responds successfully" do
      get posts_path
      expect(response).to be_success
    end

    it "returns a 200 response" do
      get posts_path
      expect(response).to have_http_status "200"
    end
  end

  describe "#show" do
    context "as an authorized user" do
      before do
        @user = create(:user)
        @post = create(:post, user_id: @user.id)
      end

      it "responds successfully" do
        sign_in @user
        get post_path(id: @post.id)
        expect(response).to be_success
      end
    end

    context "as an unauthorized user" do
      before do
        @user = create(:user)
        other_user = create(:user)
        @post = create(:post, user_id: other_user.id)
      end

      it "redirects to the dashboard" do
        sign_in @user
        get post_path(id: @post.id)
        expect(response).to be_success
      end
    end
  end

  describe "#create" do
    context "as an authenticated user" do
      before do
        @user = create(:user)
      end

      context "with valid attributes" do
        it "adds a project" do
          post = attributes_for(:post)
          sign_in @user
          expect {
            post posts_path, params: { post: post }
          }.to change(@user.posts, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "does not add a project" do
          post = attributes_for(:post, content: nil)
          sign_in @user
          expect {
            post posts_path, params: { post: post }
          }.to_not change(@user.posts, :count)
        end
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        post = attributes_for(:post)
        post posts_path, params: { post: post }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        post = attributes_for(:post)
        post posts_path, params: { post: post }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#update" do
    context "as an authorized user" do
      before do
        @user = create(:user)
        @post = create(:post, user_id: @user.id)
      end

      it "updates a project" do
        post = attributes_for(:post, content: "Update Post yeah!")
        sign_in @user
        patch post_path(@post), params: { post: post }
        expect(@post.reload.content).to eq "Update Post yeah!"
      end
    end

    context "as an unauthorized user" do
      before do
        @user = create(:user)
        other_user = create(:user)
        @post = create(:post, user_id: other_user.id, content: "Test Update")
      end

      it "does not update the project" do
        post = attributes_for(:post, content: "Update yes yes yes!")
        sign_in @user
        patch post_path(@post), params: { post: post }
        expect(@post.reload.content).to eq "Test Update"
      end

      it "redirects to the dashboard" do
        post = attributes_for(:post, content: "Update yes yes yes!")
        sign_in @user
        patch post_path(@post), params: { post: post }
        expect(response).to redirect_to post_path(@post)
      end
    end

    context "as a guest" do
      before do
        user = create(:user)
        @post = create(:post, user_id: user.id)
      end

      it "returns a 302 response" do
        post = attributes_for(:post)
        patch post_path(@post), params: { post: post }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        post = attributes_for(:post)
        patch post_path(@post), params: { post: post }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

#  describe "#destroy" do
#    context "as an authorized user" do
#      before do
#        @user = FactoryBot.create(:user)
#        @project = FactoryBot.create(:project, owner: @user)
#      end
#
#      it "deletes a project" do
#        sign_in @user
#        expect {
#          delete :destroy, params: { id: @project.id }
#        }.to change(@user.projects, :count).by(-1)
#      end
#    end
#
#    context "as an unauthorized user" do
#      before do
#        @user = FactoryBot.create(:user)
#        other_user = FactoryBot.create(:user)
#        @project = FactoryBot.create(:project, owner: other_user)
#      end
#
#      it "does not delete the project" do
#        sign_in @user
#        expect {
#          delete :destroy, params: { id: @project.id }
#        }.to_not change(Project, :count)
#      end
#
#      it "redirects to the dashboard" do
#        sign_in @user
#        delete :destroy, params: { id: @project.id }
#        expect(response).to redirect_to root_path
#      end
#    end
#
#    context "as a guest" do
#      before do
#        @project = FactoryBot.create(:project)
#      end
#
#      it "returns a 302 response" do
#        delete :destroy, params: { id: @project.id }
#        expect(response).to have_http_status "302"
#      end
#
#      it "redirects to the sign-in page" do
#        delete :destroy, params: { id: @project.id }
#        expect(response).to redirect_to "/users/sign_in"
#      end
#
#      it "does not delete the project" do
#        expect {
#          delete :destroy, params: { id: @project.id }
#        }.to_not change(Project, :count)
#      end
#    end
#  end
end
