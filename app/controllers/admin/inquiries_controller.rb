class Admin::InquiriesController < ApplicationController
  before_action :authenticate_admin!
end
