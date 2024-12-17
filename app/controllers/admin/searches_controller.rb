class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search_pages
  end

  def user_room_search
    # 入力されたユーザーIDを取得し、カンマ区切りで配列に変換
    user_ids = params[:user_ids].to_s.split(",").map(&:strip).map(&:to_i)

    if user_ids.empty?
      @rooms = []
    else
      # 指定されたユーザーが共通して参加しているDMルームを取得
      @rooms = Room.joins(:entries)
                  .where(entries: { user_id: user_ids })
                  .group("rooms.id")
                  .having("COUNT(DISTINCT entries.user_id) = ?", user_ids.size)
    end
    # 検索ページで入力された情報を保持
    @content = params[:user_ids]
  end

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == "user"
      @records = User.search_for(@content, @method).page(params[:page]).per(25)
    elsif @model == "post"
      @records = Post.search_for(@content, @method).includes(:favorites, :post_comments, :post_emotions, :user).page(params[:page]).per(25)
    end
  end
end