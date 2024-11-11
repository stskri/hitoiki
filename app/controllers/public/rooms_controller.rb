class Public::RoomsController < ApplicationController
  before_action :authenticate_user!
end
