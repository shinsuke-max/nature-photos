# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.build(like_params)
    @post = @like.post
    if @like.save
      respond_to :js
    else
      flash[:alert] = 'いいねできませんでした'
      redirect_to @post
    end
  end

  def destroy
    @like = Like.find_by(id: params[:id])
    @post = @like.post
    if @like.user == current_user
      @like.destroy!
      respond_to :js
    else
      flash[:alert] = 'いいねの削除に失敗しました'
      redirect_to @post
    end
  end

  private

  def like_params
    params.permit(:post_id)
  end
end
