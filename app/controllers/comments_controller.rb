# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @comment = Comment.new(comment_params)
    @post = @comment.post
    if @comment.save
      redirect_to @post
      flash[:notice] = 'コメントしました'
    else
      redirect_to @post
      flash[:alert] = 'コメントに失敗しました'
    end
  end

  def edit
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    redirect_to root_path unless @comment.user == current_user
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    if @comment.user == current_user
      @comment.update!(comment_params)
      flash[:notice] = 'コメントが更新されました'
    else
      flash[:alert] = 'コメントの更新に失敗しました'
    end
    redirect_to @post
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    if @comment.user == current_user
      @comment.destroy!
      flash[:notice] = 'コメントが削除されました'
    else
      flash[:alert] = 'コメントの削除に失敗しました'
    end
    redirect_to root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :post_id, :comment)
  end
end
