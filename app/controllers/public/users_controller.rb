class Public::UsersController < ApplicationController
  def show
  end

  def my_page
    @user = current_user
    @post = Post.where(user: current_user)
  end

  def edit    
  end

  def update
  end
end
