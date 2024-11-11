class Admin::EmotionsController < ApplicationController
  before_action :authenticate_admin!
end
