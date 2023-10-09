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
      flash[:notice] = "更新しました"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "更新できませんでした"
      render('users/edit')
    end
  end
end
