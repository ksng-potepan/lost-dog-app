class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(username: params[:username], email: params[:email], image: params[:image])
    if @user.save
      flash[:notice] = t('flash.notices.update')
      redirect_to user_path(@user)
    else
      flash.now[:alert] = t('flash.alerts.update_fail')
      render('users/edit')
    end
  end
end
