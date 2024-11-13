class Public::InquiriesController < ApplicationController
  before_action :authenticate_user!
end
