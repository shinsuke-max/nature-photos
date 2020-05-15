class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i(show new create edit update destroy)
  def index
    @posts = Post.limit(6).order('created_at DESC')
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      redirect_to root_path
      flash[:notice] = "投稿が保存されました"
    else
      redirect_to root_path
      flash[:alert] = "投稿に失敗しました"
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post.user == current_user
      @post.update(post_params)
      flash[:notice] = "投稿が更新されました"
    else
      flash[:alert] = "投稿の更新に失敗しました"
    end
    redirect_to @post
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.user == current_user
      @post.destroy
      flash[:notice] = "投稿が削除されました"
    else
      flash[:alert] = "投稿の削除に失敗しました"
    end
    redirect_to root_path
  end

  private

    def post_params
      params.require(:post).permit(:content, :image)
    end
end
