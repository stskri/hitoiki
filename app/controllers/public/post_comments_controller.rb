class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
end
