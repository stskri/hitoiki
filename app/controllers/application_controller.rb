class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :user_signed_in?

  private
  # サイドバーに通知を表示するため、@notificationsを設定
  def set_notifications
    @notifications = current_user.passive_notifications
                    .where.not(visitor_id: current_user.id)
                    .includes(:visitor, :post, :post_comment, :message)
                    .order(created_at: :desc)
                    # .page(params[:page]).per(10) # サイドバー用に最新10件だけ取得
                    .limit(10)
  end
end
