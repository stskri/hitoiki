class Admin::MessagesController < ApplicationController
  before_action :authenticate_admin!
end
