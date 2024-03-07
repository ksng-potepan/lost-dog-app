class AmblesController < ApplicationController
  before_action :authenticate_user!

  def information
    @user = current_user
  end

  def index
    @user = current_user
    @amble = Amble.all.page(params[:page]).per(10)
    if params[:search].present?
      @amble = @amble.where('name LIKE ? or breed LIKE ? or color LIKE ? or features LIKE ?
                            or age LIKE ? or municipalities LIKE ? or area LIKE ?',
                            "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%",
                            "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    @amble = @amble.where(prefecture: params[:prefecture]) if params[:prefecture].present?
    @amble = @amble.where(size: params[:size]) if params[:size].present?
    @amble = @amble.where(gender: params[:gender]) if params[:gender].present?
    return unless params[:start_date].present? || params[:end_date].present?

    @amble = if params[:start_date].present? && params[:end_date].present?
               @amble.where(date: params[:start_date]..params[:end_date])
             elsif params[:start_date].present?
               @amble.where(date: params[:start_date]..)
             else
               @amble.where(date: ..params[:end_date])
             end
  end

  def show
    @user = current_user
    @amble = Amble.where(id: params[:id])
    @amble_user = Amble.find_by(id: params[:id])
    @current_entry = Entry.where(user_id: @user.id)
    @another_entry = Entry.where(user_id: @amble_user.user.id)

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

  def new
    @user = current_user
    @amble = Amble.new
  end

  def edit
    @user = current_user
    @amble = Amble.find(params[:id])
  end

  def create
    @user = current_user
    @amble = Amble.new(amble_params)
    @amble.user_id = current_user.id
    if @amble.save
      flash[:notice] = t('flash.notices.create')
      redirect_to amble_path(@amble)
    else
      flash.now[:alert] = t('flash.alerts.create_fail')
      render :new
    end
  end

  def update
    @user = current_user
    @amble = Amble.find(params[:id])
    @amble.user_id = current_user.id
    if @amble.update(amble_params)
      flash[:notice] = t('flash.notices.update')
      redirect_to amble_path(@amble)
    else
      flash.now[:alert] = t('flash.alerts.update_fail')
      render :edit
    end
  end

  def destroy
    @amble = Amble.find(params[:id])
    @amble.destroy
    redirect_to ambles_path
  end

  def myamble
    @user = current_user
    @amble = Amble.where(user_id: current_user.id)
  end

  def list
    @user = current_user
    @amble = Amble.where(user_id: params[:id])
  end

  private

  def amble_params
    params.require(:amble).permit(:name, :breed, :size, :gender, :color, :age, :features, :tag, :chip, :date, :time,
                                  :prefecture, :municipalities, :area, :situation, :notification, :image)
  end
end
