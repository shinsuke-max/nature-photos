class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = Post.limit(10).order('created_at DESC')
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

  private

    def post_params
      params.require(:post).permit(:content, :image)
    end
end
