class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :user_signed_in?

  private
  # サイドバーに通知を表示するため、@notificationsを設定
  def set_notifications
    @notifications = current_user.passive_notifications
                    .where.not(visitor_id: current_user.id) # 自分から自分へのものは除く
                    .where(is_active: true) # アクティブの通知のみに絞り込み
                    .includes(:visitor, :post, :post_comment, :message)
                    .order(created_at: :desc) # 新着が上になるよう指定
                    .page(params[:page]).per(25) # サイドバー用に最新25件だけ取得
  end
end
