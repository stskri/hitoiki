class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def following_post
    @following_users = current_user.followings
    @posts = Post.includes(:favorites, :post_comments, :post_emotions, :user)
            .where(user_id: @following_users.pluck(:id))
            .page(params[:page]).per(25)
  end

  def new
    @post = Post.new
    @emotions = Emotion.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      # posts#newのフォームから送られたEmotionの情報を取得
      emotion_ids = params[:post][:post_emotions].reject(&:empty?)
      emotions = Emotion.where(id: emotion_ids)
      emotions.each do |emotion|
        @post.post_emotions.create(
          post_id: @post.id,
          emotion_id: emotion.id,
          emotion_name: emotion.name,
          emotion_color: emotion.color
        )
      end
      redirect_to posts_path, notice: '投稿しました'
    else
      redirect_to new_post_path, alert: '投稿に失敗しました'
    end
  end

  def index
    # public/posts_pathをroot_pathに指定、未ログインユーザーの場合はログインページへ
    unless user_signed_in?
      redirect_to new_user_session_path and return
    end
    @posts = Post.includes(:favorites, :post_comments, :post_emotions, :user).page(params[:page]).per(25)
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_comments = PostComment.where(post_id: @post.id)
    notifications = current_user.passive_notifications.where(checked: false, post_id: @post.id)
    notifications.update(checked: true)
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

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to root_path, alert: '無効なアクセスです'
    end
  end
end
