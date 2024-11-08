class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to root_path, notice: '投稿しました'
    else
      redirect_to new_post_path, alert: '投稿に失敗しました'
    end
  end

  def index
    @posts  = Post.includes(:user).all
  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end


  private

  def post_params
    params.require(:post).permit(:body)
  end
end
