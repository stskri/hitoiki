class Admin::SearchesController < ApplicationController
  def search_pages
  end

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == "user"
      @records = User.search_for(@content, @method)
    elsif @model == "post"
      @records = Post.search_for(@content, @method)
    end
  end
end
