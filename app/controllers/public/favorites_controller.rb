class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
end
