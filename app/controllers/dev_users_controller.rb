class DevUsersController < ApplicationController
  before_action :check_development_environment

  def index
    @users = User.all
  end

  def login
    @user = User.find(params[:id])
    sign_in @user
    redirect_to root_path, notice: "#{@user.email} としてログインしました"
  end

  private

  def check_development_environment
    redirect_to root_path unless Rails.env.development?
  end
end
