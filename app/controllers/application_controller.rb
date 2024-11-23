class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :user_signed_in?

  private
  # サイドバーに通知を表示するため、@notificationsを設定
  def set_notifications
    @notifications = current_user.passive_notifications
                    .where.not(visitor_id: current_user.id)
                    .includes(:visitor, :post, :post_comment, :message)
                    .order(created_at: :desc)
                    .page(params[:page]).per(12) # サイドバー用に最新25件だけ取得
  end
end
