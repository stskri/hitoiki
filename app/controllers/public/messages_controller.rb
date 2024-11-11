class Public::MessagesController < ApplicationController
  before_action :authenticate_user!
end
