class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    return if @user.id == current_user.id

    @current_entry.each do |current|
      @another_entry.each do |another|
        if current.room_id == another.room_id
          @is_room = true
          @room_id = current.room_id
        end
      end
    end
    return if @is_room

    @room = Room.new
    @entry = Entry.new
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    if @user.save
      flash[:notice] = t('flash.notices.update')
      redirect_to user_path(@user)
    else
      flash.now[:alert] = t('flash.alerts.update_fail')
      render('users/edit')
    end
  end

  private

  def user_params
    params.permit(:username, :email, :image)
  end
end
