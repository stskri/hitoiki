class Admin::PostCommentsController < ApplicationController
  def destroy
    comment = PostComment.find(params[:id])
    if comment.destroy
      redirect_to request.referer, notice: 'コメントを削除しました'
    else
      redirect_to request.referer, alert: 'コメントの削除に失敗しました'
    end
  end
end
