class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :not_public_post, only: [:show]
  before_action :load_draft_post, only: [:new, :create]

  def following_post
    @following_users = current_user.followings
    @posts = Post.includes(:favorites, :post_comments, :post_emotions, :user)
                  .where(is_public: true, user_id: @following_users.pluck(:id))
                  .or(Post.where(user_id: current_user.id))
                  .page(params[:page]).per(25)
  end

  def new
    @post = @draft_post || Post.new
    @emotions = Emotion.all
    @selected_emotions = session[:emotion_ids] || []
  end

  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    emotion_ids = params[:post][:post_emotions].reject(&:empty?)
    emotions = Emotion.where(id: emotion_ids)
    if post.save
      # posts#newのフォームから送られたEmotionの情報を取得
      emotions.each do |emotion|
        post.post_emotions.create(
          post_id: post.id,
          emotion_id: emotion.id,
          emotion_name: emotion.name,
          emotion_color: emotion.color
        )
      end
      @draft_post&.destroy
      session[:emotion_ids] = nil
      redirect_to posts_path, notice: '投稿しました'
    else
      save_draft_post(post)
      session[:emotion_ids] = emotion_ids
      if params[:post][:body].blank?
        redirect_to new_post_path, alert: '本文を入力して下さい'
      else
        redirect_to new_post_path, alert: '投稿に失敗しました'
      end
    end
  end

  def index
    # public/posts_pathをroot_pathに指定、未ログインユーザーの場合はログインページへ
    # 「ログインして下さい」のエラーメッセージを表示しないため、 before_action :authenticate_user! ではなく明示的にsign_inページへリダイレクトさせている
    unless user_signed_in?
      redirect_to new_user_session_path and return
    end
    @posts = Post.includes(:favorites, :post_comments, :post_emotions, :user)
                  .where(is_public: true)
                  .or(Post.where(user_id: current_user.id))
                  .page(params[:page]).per(25)
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
      if params[:post][:is_public] == "false"
        post.update_notification_is_active(false, current_user)
      elsif params[:post][:is_public] == "true"
        post.update_notification_is_active(true, current_user)
      end
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
    params.require(:post).permit(:body, :is_public)
  end

  def ensure_correct_user
    if Post.exists?(params[:id]) # 存在するかどうかをまず確認
      @post = Post.find(params[:id])
      unless @post.user == current_user
        redirect_to root_path, alert: '無効なアクセスです'
      end
    else
      redirect_to root_path, alert: "無効なアクセスです"
    end
  end

  def not_public_post
    if Post.exists?(params[:id]) # 存在するかどうかをまず確認
      post = Post.find(params[:id])
      if post.user != current_user && post.is_public == false
        redirect_to root_path, alert: "非公開の投稿です"
      end
    else
      redirect_to posts_path, alert: "無効なアクセスです"
    end
  end

  def load_draft_post
    @draft_post = current_user.draft_post
  end

  def save_draft_post(post)
    draft = current_user.draft_post || current_user.build_draft_post
    draft.body = post.body
    draft.is_public = true
    draft.save
  end
end
