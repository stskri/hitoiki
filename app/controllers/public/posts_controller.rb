class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def new
    @post = Post.new
    @emotions = Emotion.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      # @post_emotion = @post.post_emotions.build(ppost_emotion_params)
      # @post_emotion = []
      redirect_to posts_path, notice: '投稿しました'
    else
      redirect_to new_post_path, alert: '投稿に失敗しました'
    end
  end

  def index
    if user_signed_in?
      @posts  = Post.includes(:user).all.order(created_at: :desc)
      @favorited_posts = current_user.favorited_posts
    else
      redirect_to new_user_session_path
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_comments = PostComment.where(post_id: @post.id)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      redirect_to post_path(post.id), notice: '投稿を編集しました'
    else
      redirect_to edit_post_path(post.id), alert: '投稿の編集に失敗しました'
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      redirect_to posts_path, notice: '投稿を削除しました'
    else
      redirect_to post_path(post.id), alert: '投稿の削除に失敗しました'
    end
  end


  private

  def post_params
    params.require(:post).permit(:body)
  end

  def ppost_emotion_params
    params.require(:post_emotion).permit(:emotion_name, :emotion_color)
  end
end
