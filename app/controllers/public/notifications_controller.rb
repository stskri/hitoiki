class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!
end
