class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search_pages
  end

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == "user"
      @records = User.search_for(@content, @method).page(params[:page]).per(25)
    elsif @model == "post"
      @records = Post.search_for(@content, @method)
                      .includes(:favorites, :post_comments, :post_emotions, :user)
                      .where(is_public: true)
                      .or(Post.where(user_id: current_user.id))
                      .page(params[:page]).per(25)
    end
  end
end
