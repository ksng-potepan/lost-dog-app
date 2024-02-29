class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @guest_user =  User.find_by(email: 'guest@example.com')
    @target_user = User.find(params[:id])
    @current_entry = Entry.where(user_id: @user.id)
    @another_entry = Entry.where(user_id: @target_user.id)
    return if @target_user.id == @user.id

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
