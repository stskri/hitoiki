class Admin::RoomsController < ApplicationController
  before_action :authenticate_admin!
end
