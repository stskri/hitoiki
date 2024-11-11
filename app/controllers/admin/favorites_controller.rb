class Admin::FavoritesController < ApplicationController
  before_action :authenticate_admin!
end
