# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.build(like_params)
    @post = @like.post
    if @like.save
      flash[:notice] = 'いいね！しました'
    else
      flash[:alert] = 'いいねできませんでした'
    end
    redirect_to @post
  end

  def destroy
    @like = Like.find_by(id: params[:id])
    @post = @like.post
    if @like.user == current_user
      @like.destroy!
      flash[:notice] = 'いいねが取り消されました'
    else
      flash[:alert] = 'いいねの削除に失敗しました'
    end
    redirect_to @post
  end

  private

  def like_params
    params.permit(:post_id)
  end
end
